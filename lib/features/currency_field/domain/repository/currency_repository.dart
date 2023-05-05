import 'package:amwal_pay_sdk/core/base_repository/base_repository.dart';
import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/request/currency_request.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';


abstract class ICurrencyRepository extends BaseRepository {
  const ICurrencyRepository(super.networkService);

  Future<NetworkState<CurrenciesResponse>> getCurrencies(
    CurrencyRequest request,
  );
}
