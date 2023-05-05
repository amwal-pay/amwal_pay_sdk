import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';

import 'package:amwal_pay_sdk/features/wallet/data/models/request/verification_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/verify_customer_response.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/sale_by_wallet_repository.dart';

class VerifyCustomerUseCase
    extends IUseCase<VerifyCustomerResponse, WalletMobileVerificationRequest> {
  final SaleByWalletRepository saleByWalletRepository;

  VerifyCustomerUseCase(this.saleByWalletRepository);

  @override
  Future<NetworkState<VerifyCustomerResponse>> invoke(
    WalletMobileVerificationRequest param,
  ) async {
    return await saleByWalletRepository.verifyCustomer(param);
  }
}
