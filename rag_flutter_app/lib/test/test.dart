import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<void> streamAPI() async {
  final url = 'https://dashscope.aliyuncs.com/api/v1/apps/6ebdd11b33d5472bb79a8be9d765dd95/completion';
  final apiKey = 'sk-a773ce859fee421db641bdeec6f2bcfe';
  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
    'X-DashScope-SSE': 'enable',
  };

  final body = jsonEncode({
    'input': {'prompt': '你是谁？'},
    'parameters': {'incremental_output': true},
    'debug': {},
  });

  final client = http.Client();
  try {
    final request = http.Request('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.body = body;
    final response = await client.send(request);

    if (response.statusCode == 200) {
      final stream = response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (var line in stream) {
        if (line.startsWith('data:')) {
          final jsonString = line.substring(5).trim();
          if (jsonString.isNotEmpty) {
            try {
              final data = jsonDecode(jsonString);
              final text = data['output']?['text'];
              if (text != null) {
                stdout.write(text);
              }
            } catch (e) {
              stderr.writeln('解析 JSON 出现错误: $e');
            }
          }
        }
      }
    } else {
      stderr.writeln('请求错误: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    stderr.writeln('请求过程中发生异常: $e');
  } finally {
    client.close();
  }
}

void main() async {
  await streamAPI();
}
