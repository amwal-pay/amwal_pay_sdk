import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('ERROR=> ${err.error}');
      print('ERROR=> ${err.response}');
      print('ERROR=> ${err.message}');
      print('ERROR=> ${err.stackTrace}');
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('Response => ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('Request Uri => ${options.uri}');
      print('Request Method => ${options.method}');
      print('Request body => ${options.data}');
      print('Request header => ${options.headers}');
    }
    super.onRequest(options, handler);
  }
}
