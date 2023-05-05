import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomLogInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('ERROR=> ${err.error}');
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
    }
    super.onRequest(options, handler);
  }
}
