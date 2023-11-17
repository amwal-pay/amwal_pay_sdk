import 'dart:io';

import 'package:amwal_pay_sdk/core/networking/custom_log_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/dio_client.dart';
import 'package:amwal_pay_sdk/core/networking/mockup_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';

class NetworkServiceBuilder {
  const NetworkServiceBuilder._();
  static NetworkServiceBuilder get instance => const NetworkServiceBuilder._();
  DioClient _initDioClientWithInterceptors(
    bool isMocked,
    String secureHashValue,
    String token,
    String language,
    HttpClient? client,
  ) {
    final tokenInterceptor = TokenInjectorInterceptor();
    TokenInjectorInterceptor.token = token;
    final mockupInterceptor = MockupInterceptor(isMocked);
    final secureHashInterceptor = SecureHashInterceptor(
      secureHashValue: secureHashValue,
    );
    if (language == 'ar') {
      CustomLogInterceptor.language = 'ar-EG';
    } else {
      CustomLogInterceptor.language = 'en-US';
    }

    return DioClient(
      mockupInterceptor,
      secureHashInterceptor,
      tokenInterceptor,
      client,
    );
  }

  NetworkService setupNetworkService(
    bool isMocked,
    String secureHashValue,
    String token,
    String language, {
    void Function(Object e, StackTrace stack)? onError,
    Future<String?> Function()? onTokenExpired,
    HttpClient? client,
  }) =>
      NetworkService(
        _initDioClientWithInterceptors(
          isMocked,
          secureHashValue,
          token,
          language,
          client,
        ),
        onError: onError,
        onTokenExpired: onTokenExpired,
      );
}
