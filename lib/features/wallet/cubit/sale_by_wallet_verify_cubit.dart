import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/verification_request.dart';

import 'package:amwal_pay_sdk/features/wallet/data/models/response/verify_customer_response.dart';

class SaleByWalletVerifyCubit extends ICubit<VerifyCustomerResponse>
    with UiState<VerifyCustomerResponse> {
  final IUseCase<VerifyCustomerResponse, WalletMobileVerificationRequest>
      _verifyCustomerUseCase;

  SaleByWalletVerifyCubit(this._verifyCustomerUseCase);

  Future<void> verifyCustomer(
    WalletMobileVerificationRequest request,
  ) async {
    emit(const ICubitState<VerifyCustomerResponse>.loading());
    final networkState = await _verifyCustomerUseCase.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }
}
