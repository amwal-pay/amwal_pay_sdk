import 'package:amwal_pay_sdk/core/networking/network_state.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';

import '../../data/models/response/merchant_name_response.dart';

abstract class TransactionRepository {
  Future<NetworkState<OneTransactionResponse>> getTransactionById(
    Map<String, dynamic> data,
  );


  Future<NetworkState<MerchantDataResponse>> getMerchantData(
    Map<String, dynamic> data,
  );
}
