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
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    if (mockupRequest == true) {
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
      if (response.data['success']) {
        return NetworkState<T>.success(data: converter(response.data));
      } else {
        return NetworkState<T>.error(
          message: response.data['message'],
          errorList: (response.data['errorList'] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );
      }
    } on DioException catch (e, stack) {
      debugPrint(e.toString());
      onError?.call(e, stack);
      if (e.response?.statusCode == 401) {
        final token = await onTokenExpired?.call();
        if (token != null) {
          TokenInjectorInterceptor.token = token;
          return await invokeRequest(
            endpoint: endpoint,
            method: method,
            converter: converter,
            data: data,
            queryParams: queryParams,
          );
        }
        return const NetworkState.error(
          message: "UnAuthorized",
        );
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

enum HttpMethod {
  get,
  post,
  put,
  delete,
}
