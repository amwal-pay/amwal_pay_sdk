import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomLogInterceptor extends Interceptor {
  static String language = 'en-US';
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final packageInfo = await PackageInfo.fromPlatform();
    options.headers['version'] = packageInfo.version;
    options.headers['build_number'] = packageInfo.buildNumber;
    options.headers['Accept-Language'] = language;
    if (SDKNetworkConstants.isSdkInApp) {
      final token = CacheStorageHandler.instance.read(CacheKeys.sessionToken);
      if (options.uri
          .toString()
          .contains(SDKNetworkConstants.getSDKSessionToken)) {
        options.headers['authority'] = 'localhost';
        options.headers['accept'] = 'text/plain';
      } else {
        options.headers['authorization'] = 'Bearer $token';
      }
    }

    if (kDebugMode) {
      print('Request Uri => ${options.uri}');
      print('Request Method => ${options.method}');
      print('Request body => ${options.data}');
      print('Request header => ${options.headers}');
    }
    super.onRequest(options, handler);
  }
}
