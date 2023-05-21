import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/dynamic_qr_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';

class SaleByQrCubit extends ICubit<QRResponse> with UiState<QRResponse> {
  final IUseCase<QRResponse, DynamicQRRequest> _payWithQrCode;
  SaleByQrCubit(this._payWithQrCode);

  Future<void> payWithQr({
    required int terminalId,
    required int currencyId,
    required int merchantId,
    required num amount,
  }) async {
    emit(const ICubitState.loading());
    final request = DynamicQRRequest(
      currencyId: currencyId,
      terminalId: terminalId,
      merchantId: merchantId,
      amount: amount,
    );
    final networkState = await _payWithQrCode.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }
}
