import 'package:amwal_pay_sdk/core/base_repository/base_repository.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/customer_token_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';

abstract class ISaleByCardRepository extends BaseRepository {
  ISaleByCardRepository(super.networkService);

  Future<NetworkState<PurchaseResponse>> purchase(
    PurchaseRequest request,
  );
  Future<NetworkState<PurchaseResponse>> purchaseWithOtpStepOne(
    PurchaseRequest request,
  );
  Future<NetworkState<PurchaseResponse>> purchaseWithOtpStepTwo(
    PurchaseRequest request,
  );
  Future<NetworkState<PurchaseResponse>> payWithToken(
    PurchaseRequest request,
  );
  Future<NetworkState<CustomerTokenResponse>> getCustomerTokens(
    CustomerTokenRequest request,
  );
}
