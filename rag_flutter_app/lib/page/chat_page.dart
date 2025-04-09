import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        AlertDialog,
        Align,
        Alignment,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Center,
        CheckboxListTile,
        Colors,
        Column,
        Container,
        Divider,
        EdgeInsets,
        ElevatedButton,
        Expanded,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        ListTile,
        ListView,
        MouseRegion,
        Navigator,
        OutlineInputBorder,
        Padding,
        PopupMenuButton,
        PopupMenuItem,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SizedBox,
        SnackBar,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextButton,
        TextEditingController,
        TextField,
        TextStyle,
        Widget,
        showDialog;
import 'package:provider/provider.dart';
import 'package:rag_flutter_app/provider/global_provider.dart';

import '../provider/auth_provider.dart';
import '../provider/chat_provider.dart';
import '../provider/knowledge_provider.dart';

// 主界面
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChatScreen();
  }
}

// 聊天界面
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatItem extends StatefulWidget {
  final ChatProvider chatProvider;
  final ChatSession chat;

  const _ChatItem({required this.chatProvider, required this.chat});

  @override
  State<_ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<_ChatItem> {
  void _showRenameDialog(
    BuildContext context,
    ChatProvider chatProvider,
    ChatSession chat,
  ) {
    TextEditingController controller = TextEditingController(text: chat.title);

    showDialog(
      context:
          Navigator.of(context, rootNavigator: true).context, // ✅ 使用全局 context
      builder: (context) {
        return AlertDialog(
          title: const Text("重命名聊天"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "输入新名称"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  // ✅ 避免在被销毁的 context 上调用
                  chatProvider.renameChat(chat.id, controller.text);
                  Navigator.pop(context);
                }
              },
              child: const Text("确认"),
            ),
          ],
        );
      },
    );
  }

  // 更多操作按钮
  Widget _buildMoreOptionsButton(
    BuildContext context,
    ChatProvider chatProvider,
    ChatSession chat,
  ) {
    return StatefulBuilder(
      builder: (context, setState) {
        return PopupMenuButton<String>(
          enabled: chat.id.isNotEmpty,
          tooltip: '更多操作',
          icon: const Icon(Icons.more_vert),
          // // ✅ 检查菜单是否弹出
          //  onOpened: () => debugPrint("PopupMenu 打开了"),
          // // ✅ 检查菜单是否取消
          //  onCanceled: () => debugPrint("PopupMenu 取消"),
          onSelected: (value) {
            // debugPrint("PopupMenu 选中了: $value");
            if (value == 'rename') {
              _showRenameDialog(context, chatProvider, chat);
            } else if (value == 'delete') {
              chatProvider.deleteChat(chat.id);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'rename', child: Text("重命名")),
                const PopupMenuItem(value: 'delete', child: Text("删除")),
              ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // onEnter: (_) => setState(() => isHovering = true),
      // onExit: (_) => setState(() => isHovering = false),
      child: ListTile(
        title: Text(widget.chat.title),
        onTap: () => widget.chatProvider.selectChat(widget.chat),
        selected: widget.chatProvider.activeChat?.id == widget.chat.id,
        tileColor:
            widget.chatProvider.activeChat?.id == widget.chat.id
                ? Colors.blue[100]
                : null,
        trailing: _buildMoreOptionsButton(
          context,
          widget.chatProvider,
          widget.chat,
        ),
      ),
    );
  }
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: _buildChatHistory(context)), // 左侧聊天历史
          Expanded(flex: 3, child: _buildChatArea(context)), // 右侧对话框
        ],
      ),
    );
  }

  // 左侧聊天历史
  Widget _buildChatHistory(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Container(
      color: Colors.grey[200],
      child: Column(
        children: [
          ListTile(
            title: const Text("新建聊天"),
            leading: const Icon(Icons.add),
            onTap: () => chatProvider.startNewChat(),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: chatProvider.chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatProvider.chatHistory[index];
                return _ChatItem(chatProvider: chatProvider, chat: chat);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnowledgeSelectionButton(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => _showKnowledgeSelectionDialog(context),
        child: Text(
          chatProvider.selectedPipelineIds.isEmpty
              ? "选择知识库"
              : "已选择 ${chatProvider.selectedPipelineIds.length} 个知识库",
        ),
      ),
    );
  }

  void _showKnowledgeSelectionDialog(BuildContext context) async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final knowledgeProvider = Provider.of<KnowledgeProvider>(
      context,
      listen: false,
    );

    List<String> selectedIds = List.from(chatProvider.selectedPipelineIds);

    // 确保知识库数据已加载
    if (knowledgeProvider.knowledgeBases.isEmpty &&
        authProvider.userId != null) {
      await knowledgeProvider.loadKnowledgeBases(authProvider.userId!);
    }

    if (!context.mounted) return; // 确保 context 仍然有效
    if (chatProvider.sessionId.isEmpty && chatProvider.newChatSession == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("请选择聊天")));
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          // ✅ 确保 setState 在正确的 StatefulBuilder 作用域中
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: const Text("选择知识库"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: knowledgeProvider.knowledgeBases.length,
                  itemBuilder: (context, index) {
                    final base = knowledgeProvider.knowledgeBases[index];
                    final isSelected = selectedIds.contains(base.id);

                    return CheckboxListTile(
                      title: Text(base.name),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedIds.add(base.id);
                          } else {
                            selectedIds.remove(base.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("取消"),
                ),
                TextButton(
                  onPressed: () {
                    // if (selectedIds.isEmpty) {
                    //   // ✅ 如果没有选择任何知识库，提示用户并阻止操作
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("请至少选择一个知识库")),
                    //   );
                    //   return;
                    // }
                    chatProvider.selectPipelineIds(selectedIds);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("确认"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // 右侧对话框
  Widget _buildChatArea(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatSession = chatProvider.activeChat;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          color: Colors.blue,
          child: Text(
            chatSession?.title ?? "请选择聊天",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        _buildKnowledgeSelectionButton(context), // ✅ 选择知识库按钮
        Expanded(
          child:
              chatSession == null
                  ? const Center(child: Text("请选择一个聊天"))
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: chatSession.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatSession.messages[index];
                      return Align(
                        alignment:
                            message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                message.isUser
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(message.text),
                        ),
                      );
                    },
                  ),
        ),
        _buildMessageInput(context),
      ],
    );
  }

  // 底部输入框
  Widget _buildMessageInput(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final activeChat = chatProvider.activeChat;
    final messageController = chatProvider.messageController;
    final needSpeak = Provider.of<GlobalProvider>(context).needSpeak;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // 语音录制按钮
          IconButton(
            icon: Icon(
              chatProvider.isRecording ? Icons.mic_off : Icons.mic,
              color: chatProvider.isRecording ? Colors.red : Colors.blue,
            ),
            onPressed: activeChat != null?() {
              chatProvider.toggleRecording();
            }: null,
          ),
          Expanded(
            child: TextField(
              controller: messageController, // ✅ 直接使用 Provider 中的 controller
              decoration: InputDecoration(
                enabled: activeChat != null,
                hintText: "输入消息或点击语音...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              if (messageController.text.isNotEmpty) {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                chatProvider.sendMessage(
                  messageController.text,
                  authProvider.userId!,
                  needSpeak
                );
                messageController.clear();
              }
            },
          ),
          // 显示录音时长
          if (chatProvider.isRecording)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '录音时长: ${chatProvider.recordingDuration.inSeconds}秒',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
