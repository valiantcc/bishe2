import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../api/dash_scope_api.dart';
import '../api/http.dart';
import '../data/server_data.dart';

// 聊天消息模型
class ChatMessage {
  String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

// 聊天会话模型
class ChatSession {
  String id;
  String title;
  final List<ChatMessage> messages;

  ChatSession({required this.id, required this.title, required this.messages});
}

// Provider 管理聊天状态
class ChatProvider with ChangeNotifier {
  List<ChatSession> chatHistory = [];

  /// 当前聊天
  ChatSession? activeChat;
  ChatSession? newChatSession; // ✅ 先暂存新聊天，等发送消息后再添加
  String sessionId = '';
  final DashScopeApi _api = DashScopeApi();
  final TextEditingController messageController =
      TextEditingController(); // ✅ 添加一个输入控制器
  List<String> selectedPipelineIds = []; // ✅ 存储用户选择的知识库 ID
  final AudioRecorder _recorder = AudioRecorder(); // ✅ 替代 Record()
  bool _isRecording = false;
  String? _recordedFilePath;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  // 在 ChatProvider 中添加录音时长
  Duration _recordingDuration = Duration.zero;

  Duration get recordingDuration => _recordingDuration;

  bool get isRecording => _isRecording;
  Timer? _recordingTimer;

  @override
  void dispose() {
    messageController.dispose(); // ✅ 释放输入控制器，防止内存泄漏和状态保留
    super.dispose();
  }

  ChatProvider() {
    _initTts();
  }

  // 初始化 TTS
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("zh-CN"); // 默认中文
    await _flutterTts.setPitch(1.0); // 语调
    await _flutterTts.setSpeechRate(0.5); // 语速
    await _flutterTts.awaitSpeakCompletion(true); // 等待语音播放完成
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    if (_isSpeaking) {
      await _flutterTts.stop(); // 停止当前播放
      _isSpeaking = false;
    }
    // 自动检测中英文，分别设置不同的语言
    if (_containsChinese(text)) {
      await _flutterTts.setLanguage("zh-CN"); // 中文模式
    } else {
      await _flutterTts.setLanguage("en-US"); // 英文模式
    }
    _isSpeaking = true;
    notifyListeners();
    await _flutterTts.speak(text); // 朗读文本
  }

  bool _containsChinese(String text) {
    return RegExp(r'[\u4e00-\u9fa5]').hasMatch(text);
  }

  Future<void> clear() async {
    chatHistory.clear();
    activeChat = null;
    sessionId = '';
    newChatSession = null;
    _isRecording = false;
    _recordedFilePath = null;
    _recordingDuration = Duration.zero;
    messageController.clear();
    selectedPipelineIds.clear();
    notifyListeners();
  }

  /// 处理录音按钮的点击
  Future<void> toggleRecording() async {
    if (_isRecording) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  /// 开始录音
  Future<void> startRecording() async {
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _recordingDuration += Duration(seconds: 1);
      notifyListeners();
    });
    final dir = await getApplicationDocumentsDirectory();
    _recordedFilePath = '${dir.path}/recording.wav';
    await _recorder.start(
      RecordConfig(encoder: AudioEncoder.wav), // ✅ 传入录音配置
      path: _recordedFilePath!,
    );
    _isRecording = true;
    notifyListeners();
  }

  /// 停止录音并发送到 ASR
  Future<void> stopRecording() async {
    _recordingTimer?.cancel();
    _recordingDuration = Duration.zero;
    final path = await _recorder.stop();
    _isRecording = false;
    notifyListeners();

    if (path != null) {
      _recordedFilePath = path;
      await sendAudioToASR();
      // 删除录音文件
      final file = File(_recordedFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// 发送音频到 ASR 并解析文本
  Future<void> sendAudioToASR() async {
    if (_recordedFilePath == null) return;

    try {
      final bytes = await File(_recordedFilePath!).readAsBytes();
      final encodedAudio = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("http://localhost:2002/asr"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"wav": encodedAudio}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData["code"] == 0) {
          final recognizedText = responseData["res"];
          print("ASR 解析结果: $recognizedText");
          messageController.text = recognizedText;
          notifyListeners();
        }
      }
    } catch (e) {
      print("ASR 解析失败: $e");
    }
  }

  void selectPipelineIds(List<String> pipelineIds) {
    selectedPipelineIds = pipelineIds;
    notifyListeners();
  }

  void selectChat(ChatSession session) async {
    activeChat = session;
    if (sessionId == session.id || session.id.isEmpty) {
      print("已选中的会话，无需重新加载");
      return;
    } else {
      newChatSession = null;
      print("重新加载会话历史");
      messageController.clear(); // ✅ 选中新的聊天时清空输入框
      activeChat?.messages.clear();
      if (_isSpeaking) {
        await _flutterTts.stop(); // 停止当前播放
        _isSpeaking = false;
      }
    }
    sessionId = session.id;
    // 加载聊天历史
    await loadChatHistoryBySessionId(sessionId);
    notifyListeners();
  }

  void startNewChat() {
    if (newChatSession == null) {
      // ✅ 只创建一个临时的会话，不立即加入 chatHistory
      newChatSession = ChatSession(
        id: "",
        title: "新聊天${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}",
        messages: [],
      );
      activeChat = newChatSession;
      sessionId = "";
      messageController.clear(); // ✅ 选中新的聊天时清空输入框
      notifyListeners();
    }
  }

  // 删除聊天
  void deleteChat(String chatId) {
    chatHistory.removeWhere((chat) => chat.id == chatId);
    if (activeChat?.id == chatId) {
      activeChat = null; // 如果删除的是当前聊天，则清空
    }
    Http().delete(
      '/history/remove/$chatId',
      {},
      {},
      (response) {},
      (response) {},
      (json) {},
    );
    notifyListeners();
  }

  // 重命名聊天
  void renameChat(String chatId, String newTitle) {
    final chat = chatHistory.firstWhere((chat) => chat.id == chatId);
    chat.title = newTitle;
    Http().put(
      '/history/update',
      {'sessionId': chatId, 'name': newTitle},
      Http.jsonHeaders,
      (response) {},
      (response) {},
      (json) {},
    );
    notifyListeners();
  }

  Future<void> sendMessage(String text, int userId, bool needSpeak) async {
    if (activeChat == null) return;
    var chatSession = activeChat;
    var messages = chatSession!.messages;
    var saveChatSession = newChatSession;
    // 添加用户消息
    messages.add(ChatMessage(text: text, isUser: true));
    // 保存用户的消息,先判断是否是新聊天,如果不是则发送聊天内容到服务器
    if (sessionId.isNotEmpty) {
      Http().post(
        '/history/content',
        ChatContentAddDto(
          sessionId: sessionId,
          isUser: true,
          content: text,
        ).toJson(),
        Http.jsonHeaders,
        (response) {},
        (response) {},
        (json) {},
      );
    }
    notifyListeners();

    // 添加 AI 的初始消息
    final aiMessage = ChatMessage(text: "", isUser: false);
    messages.add(aiMessage);
    notifyListeners();
    var resultSessionId = '';
    // 异步获取流式响应
    try {
      final responseStream = await _api.sendStreamRequest(
        text,
        sessionId: sessionId,
        pipelineIds: selectedPipelineIds, // ✅ 发送所选知识库
      );
      // 逐步更新 AI 的消息
      responseStream.listen(
        (chunk) {
          final lastMessage = messages.last;
          if (!lastMessage.isUser) {
            var text = '';
            try {
              final Map<String, dynamic> jsonData = jsonDecode(chunk);
              text = jsonData['output']?['text'] ?? '';
              resultSessionId = jsonData['output']?['session_id'] ?? '';
            } catch (e) {
              print(e);
            }
            lastMessage.text += text;
            notifyListeners();
          }
        },
        onDone: () async {
          final lastMessage = messages.last;
          if (needSpeak) {
            speak(lastMessage.text);
          }
          // 判断一下sessionId是否相同如果不同则表示是新聊天,需要更新sessionId
         await saveChatHistory(
            resultSessionId,
            userId,
            chatSession,
            saveChatSession,
          );
        },
        onError: (error) {
          final lastMessage = messages.last;
          if (!lastMessage.isUser) {
            lastMessage.text = "请求失败: $error";
            notifyListeners();
          }
        },
      );
    } catch (e) {
      final lastMessage = messages.last;
      if (!lastMessage.isUser) {
        lastMessage.text = "请求异常: $e";
        notifyListeners();
      }
    }
  }

  Future<void> saveChatHistory(
    String resultSessionId,
    int userId,
    ChatSession chatSession,
    ChatSession? saveChatSession,
  ) async {
    // 判断一下sessionId是否相同如果不同则表示是新聊天,需要更新sessionId
    if (sessionId != resultSessionId) {
      sessionId = resultSessionId;
      chatSession.id = resultSessionId;
      await Http().post(
        '/history/save',
        ChatSessionSaveDto(
          userId: userId,
          name: chatSession.title,
          sessionId: sessionId,
          chatContents:
              chatSession.messages
                  .map((e) => ChatContentDto(isUser: e.isUser, content: e.text))
                  .toList(),
        ).toJson(),
        {'Content-Type': 'application/json'},
        (response) {
          if (saveChatSession != null) {
            chatHistory.insert(0, saveChatSession);
          }
          newChatSession = null;
          notifyListeners();
        },
        (response) {},
        (json) {},
      );
    } else {
      // 否则是继续聊天,不需要更新sessionId,直接添加AI的消息
      Http().post(
        '/history/content',
        ChatContentAddDto(
          sessionId: sessionId,
          isUser: false,
          content: chatSession.messages.last.text,
        ).toJson(),
        {'Content-Type': 'application/json'},
        (response) {},
        (response) {},
        Serializable.fromJson,
      );
    }
  }

  /// 根据会话id获取聊天历史
  Future<void> loadChatHistoryBySessionId(String sessionId) async {
    // 根据会话id获取聊天历史
    await Http().get<List<ChatContentDto>>(
      '/history/$sessionId/contents',
      {},
      {},
      (response) {
        for (var value in response.data!) {
          activeChat?.messages.add(
            ChatMessage(text: value.content, isUser: value.isUser),
          );
        }
      },
      (response) {
        print(response.data);
      },
      (json) {
        return Serializable.fromJsonList(json, ChatContentDto.fromJson);
      },
    );
  }

  Future<void> loadChatHistory(int userId) async {
    // 从服务器获取聊天历史
    await Http().get<List<ChatSessionDto>>(
      '/history/list',
      {'userId': userId.toString()},
      {},
      (response) {
        print(response.data);
        chatHistory.clear();
        for (var value in response.data!) {
          chatHistory.add(
            ChatSession(id: value.sessionId, title: value.name, messages: []),
          );
        }
        notifyListeners();
      },
      (response) {
        print(response.data);
      },
      (json) {
        return Serializable.fromJsonList(json, ChatSessionDto.fromJson);
      },
    );
  }
}
