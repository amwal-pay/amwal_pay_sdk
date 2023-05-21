import 'package:amwal_pay_sdk/core/networking/custom_log_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/mockup_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';


import 'constants.dart';

class DioClient {
  late final Dio _dio;
  final MockupInterceptor _mockupInterceptor;
  final SecureHashInterceptor _secureHashInterceptor;
  final TokenInjectorInterceptor _tokenInjectorInterceptor;

  DioClient(
    this._mockupInterceptor,
    this._secureHashInterceptor,
    this._tokenInjectorInterceptor,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
      ),
    )..interceptors.addAll([
        _tokenInjectorInterceptor,
        _secureHashInterceptor,
        _mockupInterceptor,
        ChuckerDioInterceptor(),
        CustomLogInterceptor(),
      ]);
  }

  Future<Response> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
    String? mockupResponsePath,
  }) async {
    return await _dio.get(
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
    return await _dio.post(
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
    return await _dio.put(
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
      await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
}
