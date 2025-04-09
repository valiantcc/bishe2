import 'dart:convert';

import 'package:http/http.dart' as http;

// import 'package:uuid/uuid.dart';
class ResponseWrapper<T> {
  final String code;
  final String message;
  final T? data;

  ResponseWrapper({required this.code, required this.message, this.data});

  // 从 JSON 解析
  factory ResponseWrapper.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ResponseWrapper<T>(
      code: json['code'] ?? '999999',
      message: json['message'] ?? '未知错误',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class Http {
  final http.Client _client = http.Client();
  static final Http _instance = Http._internal();

  factory Http() => _instance;

  static const String baseUrl = "http://49.235.96.75:8081";
  static const Duration timeout = Duration(seconds: 30);
  static const Map<String, String> formHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
  };
  // final Uuid _uuid = Uuid();

  Http._internal();

  Map<String, String> _defaultHeaders({Map<String, String>? headers}) {
    if (headers == null||headers.isEmpty) {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer your_token',
        // 'X-Request-Id': _uuid.v4(),
      };
    }else{
      return {
        ...headers,
      };
    }
  }

  Future<void> _handleResponse<T>(
    http.Response response,
    Function(ResponseWrapper<T>) successCallback,
    Function(ResponseWrapper<T>) failureCallback,
    T Function(dynamic) fromJsonT,
  ) async {
    var decoded = utf8.decode(response.bodyBytes);
    print("请求成功: ${response.statusCode} - $decoded");
    if(decoded.isEmpty){
      decoded = "{}";
    }
    final dynamic responseData = jsonDecode(decoded);
    final parsedResponse = ResponseWrapper<T>.fromJson(responseData, fromJsonT);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseData['code'] == "000000") {
        successCallback(parsedResponse);
      } else {
        failureCallback(parsedResponse);
      }
    } else {
      print(
        "请求失败: ${response.statusCode} - ${responseData['message'] ?? response.body}",
      );
    }
  }

  Future<void> get<T>(
    String endpoint,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Function(ResponseWrapper<T>) successCallback,
    Function(ResponseWrapper<T>) failureCallback,
    T Function(dynamic) fromJsonT,
  ) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      print("准备发送 GET 请求: $uri, 参数: $params, 头信息: $headers");
      final response = await _client
          .get(uri, headers: _defaultHeaders(headers: headers))
          .timeout(timeout);
      print("服务器返回状态码: ${response.statusCode}");
      await _handleResponse(
        response,
        successCallback,
        failureCallback,
        fromJsonT,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> post<T>(
    String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Function(ResponseWrapper<T>) successCallback,
    Function(ResponseWrapper<T>) failureCallback,
    T Function(dynamic) fromJsonT,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _defaultHeaders(headers: headers),
            body: jsonEncode(data),
          )
          .timeout(timeout);
      await _handleResponse(
        response,
        successCallback,
        failureCallback,
        fromJsonT,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> put<T>(
    String endpoint,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Function(ResponseWrapper) successCallback,
    Function(ResponseWrapper) failureCallback,
    T Function(dynamic) fromJsonT,
  ) async {
    try {
      final response = await _client
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _defaultHeaders(headers: headers),
            body: jsonEncode(data),
          )
          .timeout(timeout);
      await _handleResponse(
        response,
        successCallback,
        failureCallback,
        fromJsonT,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete<T>(
    String endpoint,
    Map<String, String>? params,
    Map<String, String>? headers,
    Function(ResponseWrapper) successCallback,
    Function(ResponseWrapper) failureCallback,
    T Function(dynamic) fromJsonT,
  ) async {
    try {
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: params);
      print("准备发送 DELETE 请求: $uri, 参数: $params, 头信息: $headers");
      final response = await _client
          .delete(uri, headers: _defaultHeaders(headers: headers))
          .timeout(timeout);
      print("服务器返回状态码: ${response.statusCode}");
      await _handleResponse(response, successCallback, failureCallback,fromJsonT);
    } catch (e) {
      print(e);
    }
  }
}
