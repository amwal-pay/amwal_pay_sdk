import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/request/verification_request.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/qr_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/verify_customer_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/sale_by_wallet_constant.dart';
import 'package:amwal_pay_sdk/features/wallet/domain/sale_by_wallet_repository.dart';

class SaleByWalletRepoImpl extends SaleByWalletRepository {
  SaleByWalletRepoImpl(super.networkService);

  @override
  Future<NetworkState<WalletPayResponse>> payByWallet(
    Map<String, dynamic> request,
  ) async {
    return await networkService.invokeRequest(
      data: request,
      method: HttpMethod.post,
      converter: WalletPayResponse.fromJson,
      endpoint: SaleByWalletConstant.saleByWalletEndpoint,
      mockupResponsePath: SaleByWalletConstant.saleByWalletSuccessMockup,
    );
  }

  @override
  Future<NetworkState<VerifyCustomerResponse>> verifyCustomer(
    WalletMobileVerificationRequest param,
  ) async {
    return await networkService.invokeRequest(
      data: param.toMap(),
      method: HttpMethod.post,
      queryParams: {'id': param.id},
      converter: VerifyCustomerResponse.fromJson,
      endpoint: SaleByWalletConstant.verifyCustomerEndpoint,
      mockupResponsePath: SaleByWalletConstant.verifyCustomerSuccessMockup,
    );
  }

  @override
  Future<NetworkState<QRResponse>> payWithQR(
    Map<String, dynamic> request,
  ) async {
    return await networkService.invokeRequest(
      data: request,
      method: HttpMethod.post,
      converter: QRResponse.fromJson,
      endpoint: SaleByWalletConstant.saleByQREndpoint,
      mockupResponsePath: SaleByWalletConstant.qrMockup,
    );
  }
}
