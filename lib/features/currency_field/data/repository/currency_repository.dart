import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/request/currency_request.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/currency_field/domain/currency_constants.dart';
import 'package:amwal_pay_sdk/features/currency_field/domain/repository/currency_repository.dart';


class CurrencyRepositoryImpl extends ICurrencyRepository {
  const CurrencyRepositoryImpl(super.networkService);

  @override
  Future<NetworkState<CurrenciesResponse>> getCurrencies(
    CurrencyRequest request,
  ) async {
    return await networkService.invokeRequest(
      data: request.toJson(),
      method: HttpMethod.post,
      converter: CurrenciesResponse.fromJson,
      endpoint: CurrencyConstants.currencyEndpoint,
      mockupResponsePath: CurrencyConstants.currencyMockup,
    );
  }
}
