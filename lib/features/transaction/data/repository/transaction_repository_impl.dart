import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/repository/transaction_repository.dart';

import '../models/response/merchant_name_response.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final NetworkService _networkService;

  TransactionRepositoryImpl(this._networkService);

  @override
  Future<NetworkState<OneTransactionResponse>> getTransactionById(
    Map<String, dynamic> data,
  ) async {
    await Future.delayed(const Duration(seconds: 3));
    return await _networkService.invokeRequest(
      endpoint: SDKNetworkConstants.getTransactionByIdEndpoint,
      converter: OneTransactionResponse.fromJson,
      method: HttpMethod.post,
      data: data,
    );
  }

  @override
  Future<NetworkState<MerchantDataResponse>> getMerchantData(
    Map<String, dynamic> data,
  ) async {
    Map<String, dynamic> data2 = Map<String, dynamic>.from(data);
    return await _networkService.invokeRequest(
      endpoint: SDKNetworkConstants.getMerchantNameEndpoint,
      converter: MerchantDataResponse.fromJson,
      method: HttpMethod.post,
      data: data2,
    );
  }
}
