class DashScopeConfig {
  static const String apiKey = 'sk-9175f656273741fba67d0de819cf4c0c';
  // static const String apiKey = 'sk-a773ce859fee421db641bdeec6f2bcfe';
  static const String appId = 'a0c2f8442c884311b000f0679148013f';
  // static const String appId = '6ebdd11b33d5472bb79a8be9d765dd95';
  static const String baseUrl = 'https://dashscope.aliyuncs.com/api/v1/apps/';
  // 是否启用流式输出
  static const bool incrementalOutput = true;
  static const List<String> pipelineIds = ["", "", "", ""];

  static Map<String, String> get headers => {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
    'X-DashScope-SSE': 'enable',
  };
}
