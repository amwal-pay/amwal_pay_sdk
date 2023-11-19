import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/repository/transaction_repository.dart';

class GetOneTransactionByIdUseCase
    extends IUseCase<OneTransactionResponse, Map<String, dynamic>> {
  final TransactionRepository _repository;
  GetOneTransactionByIdUseCase(this._repository);

  @override
  Future<NetworkState<OneTransactionResponse>> invoke(
    Map<String, dynamic> param,
  ) async {
    return await _repository.getTransactionById(param);
  }
}
