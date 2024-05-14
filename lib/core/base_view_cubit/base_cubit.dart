import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/ui/error_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ICubit<G> extends Cubit<ICubitState<G>> {
  ICubit() : super(const ICubitState.initial());

  void _dismissDialog(Change<ICubitState<G>> change) {
    if (change.currentState == ICubitState<G>.loading()) {
      AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
    }
  }

  void _resetState() {
    emit(const ICubitState.initial());
    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
  }

  @override
  void onChange(Change<ICubitState<G>> change) {
    super.onChange(change);
    change.nextState.whenOrNull(
      loading: () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          showDialog(
            context:
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
            builder: (_) => const LoadingDialog(),
          );
        });
      },
      error: (err, msgList) {
        _dismissDialog(change);
        String errorMessage = '';
        if (msgList?.isEmpty ?? true) {
          errorMessage = err ?? 'Something Went Wrong';
        } else {
          errorMessage = (msgList?.join(',') ?? err.toString());
        }
        if (AmwalSdkNavigator.amwalNavigatorObserver.navigator != null) {
          return showDialog(
            context:
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
            builder: (_) => ErrorDialog(
              title: err ?? '',
              message: errorMessage,
              resetState: _resetState,
            ),
          );
        }
      },
      initial: () {
        _dismissDialog(change);
      },
      success: (_) {
        _dismissDialog(change);
      },
    );
  }
}
