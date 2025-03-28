import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/core/usecase/i_use_case.dart';
import 'package:amwal_pay_sdk/features/card/data/models/request/purchase_request.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/domain/repository/sale_by_card_repo.dart';

class PayWithTokenUseCase extends IUseCase<PurchaseResponse, PurchaseRequest> {
  final ISaleByCardRepository _saleByCardRepository;
  PayWithTokenUseCase(this._saleByCardRepository);

  @override
  Future<NetworkState<PurchaseResponse>> invoke(PurchaseRequest param) async {
    return await _saleByCardRepository.payWithToken(param);
  }
}
