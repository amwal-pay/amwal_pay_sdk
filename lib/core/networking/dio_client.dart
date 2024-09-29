import 'dart:io';

import 'package:amwal_pay_sdk/core/networking/custom_log_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/mockup_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class DioClient {
  static Dio? dio;
  final MockupInterceptor _mockupInterceptor;
  final SecureHashInterceptor _secureHashInterceptor;
  final TokenInjectorInterceptor _tokenInjectorInterceptor;

  DioClient(
    this._mockupInterceptor,
    this._secureHashInterceptor,
    this._tokenInjectorInterceptor,
    HttpClient? client,
  ) {
    dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.url,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    )..interceptors.addAll([
        _tokenInjectorInterceptor,
        _secureHashInterceptor,
        _mockupInterceptor,
        CustomLogInterceptor(),
      ]);
  }

  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    String? mockupResponsePath,
  }) async {
    return await dio!.get(
      endpoint,
      queryParameters: queryParams,
    );
  }

  Future<Response> postRequest({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParams,
    String? mockupResponsePath,
  }) async {
    return await dio!.post(
      endpoint,
      data: data,
      queryParameters: queryParams,
    );
  }

  Future<Response> putRequest({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParams,
  }) async {
    return await dio!.put(
      endpoint,
      data: data,
      queryParameters: queryParams,
    );
  }

  Future<Response> deleteRequest({
    required String endpoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async =>
      await dio!.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
}
