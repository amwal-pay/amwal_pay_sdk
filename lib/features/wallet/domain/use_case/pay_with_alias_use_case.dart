import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/payment_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/sale_by_wallet_repository.dart';


class PayWithAliasUseCase
    extends IUseCase<WalletPayResponse, WalletPaymentRequest> {
  final SaleByWalletRepository _repository;
  PayWithAliasUseCase(
    this._repository,
  );
  @override
  Future<NetworkState<WalletPayResponse>> invoke(
    WalletPaymentRequest param,
  ) async {
    return await _repository.payByWallet(param.payWithAliasName());
  }
}
