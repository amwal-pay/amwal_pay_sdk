import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MockupInterceptor extends Interceptor {
  final bool isMocked;
  MockupInterceptor(this.isMocked);

  void _mockApi(RequestOptions options) {
    if (isMocked) {
      options.baseUrl = 'https://amwalpayapi.mocklab.io/';
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      _mockApi(options);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    super.onRequest(options, handler);
  }
}
