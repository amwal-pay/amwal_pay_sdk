import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';

import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';

class SaleByWalletPayCubit extends ICubit<WalletPayResponse>
    with UiState<WalletPayResponse> {
  final IUseCase<WalletPayResponse, WalletPaymentRequest>
      _payWithMobileNoUseCase;
  final IUseCase<WalletPayResponse, WalletPaymentRequest> _payWithAliasUseCase;

  SaleByWalletPayCubit(
    this._payWithAliasUseCase,
    this._payWithMobileNoUseCase,
  );

  Future<void> payByAlias(
    WalletPaymentRequest request,
  ) async {
    emit(const ICubitState<WalletPayResponse>.loading());
    final networkState = await _payWithAliasUseCase.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }

  Future<void> payWithMobile(
    WalletPaymentRequest request,
  ) async {
    emit(const ICubitState<WalletPayResponse>.loading());
    final networkState = await _payWithMobileNoUseCase.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }
}
