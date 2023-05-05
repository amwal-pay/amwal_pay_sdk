import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_state.freezed.dart';

@freezed
class NetworkState<T> with _$NetworkState<T> {
  const factory NetworkState.initial() = _Initial;
  const factory NetworkState.success({required T data}) = _Success<T>;
  const factory NetworkState.error({
    String? message,
    List<String>? errorList,
  }) = _Error;
}
