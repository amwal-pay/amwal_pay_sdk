import 'dart:convert';

import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'EncryptionUtil.dart';
import 'dio_client.dart';
import 'network_state.dart';

class NetworkService {
  final DioClient _dioClient;
  final void Function(Object e, StackTrace stack)? onError;
  final Future<String?> Function()? onTokenExpired;

  NetworkService(
    this._dioClient, {
    this.onError,
    this.onTokenExpired,
  });

  Future<Response> _httpMethodHandler({
    required String endpoint,
    required HttpMethod method,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    String? mockupResponsePath,
  }) async {
    switch (method) {
      case HttpMethod.get:
        return await _dioClient.getRequest(
          endpoint: endpoint,
          queryParams: queryParams,
          mockupResponsePath: mockupResponsePath,
        );
      case HttpMethod.post:
        return await _dioClient.postRequest(
          endpoint: endpoint,
          queryParams: queryParams,
          data: data!,
          mockupResponsePath: mockupResponsePath,
        );
      case HttpMethod.put:
        return await _dioClient.putRequest(
          endpoint: endpoint,
          queryParams: queryParams,
          data: data!,
        );
      case HttpMethod.delete:
        return await _dioClient.deleteRequest(
          endpoint: endpoint,
          queryParams: queryParams,
          data: data,
        );
    }
  }

  Future<NetworkState<T>> invokeRequest<T>({
    required String endpoint,
    required HttpMethod method,
    required T Function(dynamic) converter,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? data,
    String? mockupResponsePath,
    bool? mockupRequest,
  }) async {
    if (mockupRequest == true) {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

      String jsonString = await rootBundle.loadString(mockupResponsePath!);
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      return NetworkState<T>.success(data: converter(jsonData));
    }

    try {
      final response = await _httpMethodHandler(
        endpoint: endpoint,
        method: method,
        data: data,
        queryParams: queryParams,
        mockupResponsePath: mockupResponsePath,
      );
      if (response.data?['success'] == true) {
        return NetworkState<T>.success(data: converter(response.data));
      } else {
        return NetworkState<T>.error(
          message: response.data?['message'] ??
              'Something went wrong please, try again!',
          errorList: (response.data?['errorList'] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );
      }
    } on DioException catch (e, stack) {
      debugPrint(e.toString());
      onError?.call(e, stack);

      final networkErrorState = await _handleError<T>(e.response, () async {
        final token = await onTokenExpired?.call();
        if (token != null) {
          TokenInjectorInterceptor.token = token;
          return true;
        } else {
          return false;
        }
      });
      if (networkErrorState == null) {
        return await invokeRequest(
          endpoint: endpoint,
          method: method,
          converter: converter,
          data: data,
          queryParams: queryParams,
        );
      } else {
        return networkErrorState;
      }
      String contentType =
          e.response?.headers['content-type']?.first ?? 'unknown';

      if (contentType == "application/jose") {
        final decryptedData =
            await EncryptionUtil.makeDecryptOfJson(e.response?.data);
        e.response?.data = decryptedData;
      }

      try {
        return NetworkState<T>.error(
          message: (e.response?.data?['message'] ?? e.message),
          errorList: (e.response?.data?['errorList'] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );
      } catch (e, stack) {
        debugPrint(e.toString());
        onError?.call(e, stack);
        return NetworkState<T>.error(
          message: e.toString(),
        );
      }
    } catch (e, stack) {
      debugPrint(e.toString());
      onError?.call(e, stack);
      return NetworkState<T>.error(
        message: e.toString(),
      );
    }
  }
}

Future<NetworkState<T>?> _handleError<T>(
  Response? response,
  Future<bool> Function() onTokenExpired,
) async {
  String contentType = response?.headers['content-type']?.first ?? 'unknown';

  if (contentType == "application/jose") {
    final decryptedData =
        await EncryptionUtil.makeDecryptOfJson(response?.data);
    response?.data = decryptedData;
  }
  if (response == null) {
    return NetworkState<T>.error(
        message: 'Something went wrong please, Try Again');
  } else if (response.statusCode == 401) {
    final tokenRefreshed = await onTokenExpired();
    if (tokenRefreshed) {
      return null;
    } else {
      return NetworkState<T>.error(message: 'unAuthorized');
    }
  } else if (response.statusCode == 502) {
    return NetworkState<T>.error(message: 'Bad Gateway');
  } else if (response.statusCode == 500) {
    return NetworkState<T>.error(message: 'Server Error Try Again Later');
  } else if (response.data == null) {
    return NetworkState<T>.error(
        message: 'Something went wrong please, Try Again');
  } else {
    return NetworkState<T>.error(
        message: 'Something went wrong please, Try Again');
  }
}

enum HttpMethod {
  get,
  post,
  put,
  delete,
}
