import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';

class SaleByQrCubit extends ICubit<QRResponse> with UiState<QRResponse> {
  final IUseCase<QRResponse, WalletPaymentRequest> _payWithQrCode;
  SaleByQrCubit(this._payWithQrCode);

  Future<void> payWithQr(String terminalId) async {
    emit(const ICubitState.loading());
    final request = WalletPaymentRequest(
      transactionMethodId: 1,
      orderKey: 'orderKey',
      processingCode: 'processingCode',
      currencyId: 1,
      id: 'id',
      amount: 5,
      terminalId: terminalId,
    );
    final networkState = await _payWithQrCode.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }
}
