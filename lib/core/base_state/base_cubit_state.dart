import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_cubit_state.freezed.dart';

@freezed
class ICubitState<T> with _$ICubitState<T> {
  const factory ICubitState.initial() = _Initial;
  const factory ICubitState.loading() = _Loading;
  const factory ICubitState.success({required T uiModel}) = _Success<T>;
  const factory ICubitState.error({
    String? message,
    List<String>? errorListMsg,
  }) = _Error<T>;
}

// cubit state have both states => main state, aux state
