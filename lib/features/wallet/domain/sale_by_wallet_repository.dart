import 'package:amwal_pay_sdk/core/base_repository/base_repository.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';

import 'package:amwal_pay_sdk/features/wallet/data/models/request/verification_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/verify_customer_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';

abstract class SaleByWalletRepository extends BaseRepository {
  SaleByWalletRepository(super.networkService);

  Future<NetworkState<QRResponse>> payWithQR(
    Map<String, dynamic> request,
  );

  Future<NetworkState<WalletPayResponse>> payByWallet(
    Map<String, dynamic> request,
  );

  Future<NetworkState<VerifyCustomerResponse>> verifyCustomer(
    WalletMobileVerificationRequest param,
  );
}
