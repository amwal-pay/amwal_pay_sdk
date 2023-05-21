import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/dynamic_qr_request.dart';

import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/sale_by_wallet_repository.dart';

class PayWithQrUseCase extends IUseCase<QRResponse, DynamicQRRequest> {
  final SaleByWalletRepository _saleByWalletRepository;
  const PayWithQrUseCase(this._saleByWalletRepository);

  @override
  Future<NetworkState<QRResponse>> invoke(DynamicQRRequest param) async {
    return await _saleByWalletRepository.payWithQR(param.toMap());
  }
}
