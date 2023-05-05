import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'network_state.dart';

class NetworkService {
  final DioClient _dioClient;

  NetworkService(this._dioClient);

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
  }) async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

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
    } on DioError catch (e) {
      return NetworkState<T>.error(
        message: e.message,
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
