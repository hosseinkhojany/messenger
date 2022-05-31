import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class LoggingInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('\n');
    debugPrint(
        '--> ${options.method} ${'${options.baseUrl}${options.path}'}');
    debugPrint('Headers:');
    options.headers.forEach((k, dynamic v) => debugPrint('$k: $v'));
    debugPrint('queryParameters:');
    options.queryParameters.forEach((k, dynamic v) => debugPrint('$k: $v'));
    if (options.data != null) {
      debugPrint('Body: ${options.data}');
    }
    debugPrint(
        '--> END ${options.method}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('\n\n');
    debugPrint(
        '<--- HTTP CODE : ${response.statusCode} URL : ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    debugPrint('Headers: ');
    printWrapped('Response : ${response.data}');
    debugPrint('<--- END HTTP');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint('\n');
    debugPrint(
        '<-- ${err.message} ${err.response?.requestOptions.method != null ? (err.response!.requestOptions.baseUrl + err.response!.requestOptions.path) : 'URL'}');
    debugPrint(
        '${err.response != null ? err.requestOptions.data : 'Unknown Error'}');
    debugPrint('<-- End error');
    super.onError(err, handler);
  }

  void printWrapped(String text) {
    final RegExp pattern = RegExp('.{1,800}');
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => debugPrint(match.group(0)));
  }
}
