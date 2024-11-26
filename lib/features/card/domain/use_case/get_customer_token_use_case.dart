import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/customer_token_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/features/card/domain/repository/sale_by_card_repo.dart';

class GetCustomerTokenUseCase
    extends IUseCase<CustomerTokenResponse, CustomerTokenRequest> {
  final ISaleByCardRepository _repository;
  GetCustomerTokenUseCase(this._repository);
  @override
  Future<NetworkState<CustomerTokenResponse>> invoke(
    CustomerTokenRequest param,
  ) async {
    return await _repository.getCustomerTokens(param);
  }
}
