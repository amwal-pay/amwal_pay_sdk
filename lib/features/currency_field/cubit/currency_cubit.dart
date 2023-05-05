import 'package:amwal_pay_sdk/core/apiview/state_mapper.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/base_view_cubit/base_cubit.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/request/currency_request.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';

class CurrencyCubit extends ICubit<CurrenciesResponse>
    with UiState<CurrenciesResponse> {
  final IUseCase<CurrenciesResponse, CurrencyRequest> _getCurrenciesUseCase;
  CurrencyCubit(this._getCurrenciesUseCase);

  Future<void> getCurrencies(CurrencyRequest request) async {
    emit(const ICubitState<CurrenciesResponse>.loading());
    final networkState = await _getCurrenciesUseCase.invoke(request);
    final state = mapNetworkState(networkState);
    emit(state);
  }
}
