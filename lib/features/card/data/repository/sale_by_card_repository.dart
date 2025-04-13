import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/customer_token_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/domain/repository/sale_by_card_repo.dart';
import 'package:amwal_pay_sdk/features/card/domain/sale_by_card_constants.dart';

class SaleByCardRepositoryImpl extends ISaleByCardRepository {
  SaleByCardRepositoryImpl(super.networkService);

  @override
  Future<NetworkState<PurchaseResponse>> purchase(
    PurchaseRequest request,
  ) async {
    return await networkService.invokeRequest(
      method: HttpMethod.post,
      data: request.mapToPurchaseData(),
      converter: PurchaseResponse.fromJson,
      endpoint: SaleByCardConstants.purchaseEndpoint,
    );
  }

  @override
  Future<NetworkState<PurchaseResponse>> purchaseWithOtpStepOne(
    PurchaseRequest request,
  ) async {
    return await networkService.invokeRequest(
      data: request.mapToPurchaseStepOneData(),
      method: HttpMethod.post,
      converter: PurchaseResponse.fromJson,
      endpoint: SaleByCardConstants.purchaseEndpoint,
    );
  }


  @override
  Future<NetworkState<PurchaseResponse>> purchaseWithAppleAndSamsung(
      PurchaseRequest request,
      ) async {
    return await networkService.invokeRequest(
      data: request.mapToPurchaseAppleSamsungData(),
      method: HttpMethod.post,
      converter: PurchaseResponse.fromJson,
      endpoint: SaleByCardConstants.purchaseEndpoint,
    );
  }


  @override
  Future<NetworkState<PurchaseResponse>> purchaseWithOtpStepTwo(
    PurchaseRequest request,
  ) async {
    return await networkService.invokeRequest(
      data: request.mapToPurchaseStepTwoData(),
      method: HttpMethod.post,
      converter: PurchaseResponse.fromJson,
      endpoint: SaleByCardConstants.purchaseEndpoint,
    );
  }

  @override
  Future<NetworkState<PurchaseResponse>> payWithToken(
    PurchaseRequest request,
  ) async {
    return await networkService.invokeRequest(
      data: request.mapToPayWithToken(),
      method: HttpMethod.post,
      converter: PurchaseResponse.fromJson,
      endpoint: SaleByCardConstants.payWithTokenEndpoint,
    );
  }

  @override
  Future<NetworkState<CustomerTokenResponse>> getCustomerTokens(
    CustomerTokenRequest request,
  ) async {
    return await networkService.invokeRequest(
      endpoint: SDKNetworkConstants.getCustomerTokens,
      method: HttpMethod.post,
      converter: CustomerTokenResponse.fromJson,
      data: {},
    );
  }
}
