import 'package:dio/dio.dart';

class TokenInjectorInterceptor extends Interceptor {
  final String token;
  TokenInjectorInterceptor(this.token);
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}
