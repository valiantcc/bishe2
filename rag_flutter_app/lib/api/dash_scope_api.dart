import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dash_spe_config.dart';

class DashScopeApi {
  final http.Client _client;

  // 允许传入 http.Client 自定义客户端，默认为 http.Client()
  DashScopeApi({http.Client? client}) : _client = client ?? http.Client();

  /// 构建请求体
  static Map<String, dynamic> _buildRequestBody(
    String prompt,
    String sessionId,
    List<String> pipelineIds,
    List<String> fileIds,
  ) {
    return {
      'input': {
        'prompt': prompt,
        if (sessionId.isNotEmpty) 'session_id': sessionId,
      },
      'parameters': {
        "incremental_output": DashScopeConfig.incrementalOutput,
        if (pipelineIds.isNotEmpty)
          'rag_options': {
            'pipeline_ids': pipelineIds,
            if (fileIds.isNotEmpty) 'file_ids': fileIds,
          },
      },
      'debug': {},
    };
  }

  // 发送流式请求
  Future<Stream<String>> sendStreamRequest(
    String prompt, {
    String sessionId = '',
    List<String> pipelineIds = const [],
    List<String> fileIds = const [],
  }) async {
    final String requestUrl =
        '${DashScopeConfig.baseUrl}${DashScopeConfig.appId}/completion';
    final String jsonBody = jsonEncode(
      _buildRequestBody(prompt, sessionId, pipelineIds, fileIds),
    );
    print("请求地址: $requestUrl\n请求体: $jsonBody");
    final request =
        http.Request('POST', Uri.parse(requestUrl))
          ..headers.addAll(DashScopeConfig.headers)
          ..body = jsonBody;

    final response = await _client.send(request);
    if (response.statusCode == 200) {
      return response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .where((line) => line.startsWith('data:')) // 过滤出以 "data:" 开头的行
          .map((line) {
            print(line);
            return line.substring(5).trim(); // 截取 "data:" 后面的内容
          });
    } else {
      throw Exception('请求失败 (状态码: ${response.statusCode})');
    }
  }

  /// 发送请求
  // Future<String> sendRequest(
  //   String prompt, {
  //   List<String> pipelineIds = const [],
  //   List<String> fileIds = const [],
  // }) async {
  //   final String requestUrl =
  //       '${DashScopeConfig.baseUrl}${DashScopeConfig.appId}/completion';
  //   final String jsonBody = jsonEncode(
  //     _buildRequestBody(prompt, pipelineIds, fileIds),
  //   );
  //   try {
  //     final response = await _client.post(
  //       Uri.parse(requestUrl),
  //       headers: DashScopeConfig.headers,
  //       body: jsonBody,
  //     );
  //
  //     // 解析响应
  //     return _processResponse(response);
  //   } catch (e, stackTrace) {
  //     return '请求异常: $e\nStackTrace: $stackTrace';
  //   }
  // }

  /// 处理响应，增强了错误提示
  String _processResponse(http.Response response) {
    final responseBody = utf8.decode(response.bodyBytes);
    final Map<String, dynamic> responseJson = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      // 返回正常响应
      return responseJson['output']?['text'] ?? 'API 响应格式错误: 缺少 "output.text"';
    } else {
      // 返回错误响应信息
      return '请求失败 (状态码: ${response.statusCode})\n错误信息: ${response.body}';
    }
  }

  /// 关闭客户端
  void close() {
    _client.close();
  }
}
