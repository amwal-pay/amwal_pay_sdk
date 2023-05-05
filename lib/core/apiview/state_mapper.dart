import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:flutter/foundation.dart';

mixin UiState<T> on ICubit<T> {
  @protected
  ICubitState<T> mapNetworkState(NetworkState<T> networkState) {
    return networkState.map(
      initial: (_) => const ICubitState.initial(),
      success: (_) => ICubitState<T>.success(uiModel: _.data),
      error: (err) => ICubitState<T>.error(
        message: err.message ?? 'some thing went wrong',
        errorListMsg: err.errorList,
      ),
    );
  }
}
