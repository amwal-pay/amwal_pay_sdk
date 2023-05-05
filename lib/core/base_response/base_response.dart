abstract class BaseResponse<T> {
  final bool success;
  final int? responseCode;
  final String? message;
  final T? data;
  const BaseResponse({
    required this.success,
    this.responseCode,
    this.message,
    this.data,
  });
}
