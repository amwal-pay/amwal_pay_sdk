import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/request/currency_request.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/currency_field/domain/repository/currency_repository.dart';


class GetCurrenciesUseCase
    extends IUseCase<CurrenciesResponse, CurrencyRequest> {
  final ICurrencyRepository _currencyRepository;
  const GetCurrenciesUseCase(this._currencyRepository);

  @override
  Future<NetworkState<CurrenciesResponse>> invoke(CurrencyRequest param) async {
    return await _currencyRepository.getCurrencies(param);
  }
}
