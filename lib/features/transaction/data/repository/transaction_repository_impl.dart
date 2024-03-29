import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl extends TransactionRepository {
  final NetworkService _networkService;
  TransactionRepositoryImpl(this._networkService);
  @override
  Future<NetworkState<OneTransactionResponse>> getTransactionById(
    Map<String, dynamic> data,
  ) async {
    return await _networkService.invokeRequest(
      endpoint: NetworkConstants.getTransactionByIdEndpoint,
      converter: OneTransactionResponse.fromJson,
      method: HttpMethod.post,
      data: data,
    );
  }
}
