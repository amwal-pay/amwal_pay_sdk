import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';

import '../../amwal_sdk_settings/amwal_sdk_settings.dart';
import '../../features/transaction/data/models/response/merchant_name_response.dart';

class MerchantStore {
  const MerchantStore._();
  static MerchantStore get instance => const MerchantStore._();

  String getToken() => CacheStorageHandler.instance.read(CacheKeys.token);

  String getMerchantId() =>
      CacheStorageHandler.instance.read(CacheKeys.merchantId);

  String? getMerchantName() =>
      CacheStorageHandler.instance.read(CacheKeys.merchantName);


  MerchantData? getMerchantData() =>
      CacheStorageHandler.instance.read(CacheKeys.merchantData);
  String? getMerchantFlavor() =>
      CacheStorageHandler.instance.read(CacheKeys.merchant_flavor);
  List<String> getTerminal() =>
      CacheStorageHandler.instance.read(CacheKeys.terminals);
}
