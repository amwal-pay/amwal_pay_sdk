import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';

class MerchantStore {
  const MerchantStore._();
  static MerchantStore get instance => const MerchantStore._();

  String getToken() => CacheStorageHandler.instance.read(CacheKeys.token);

  String getMerchantId() =>
      CacheStorageHandler.instance.read(CacheKeys.merchantId);

  String? getMerchantName() =>
      CacheStorageHandler.instance.read(CacheKeys.merchantName);

  List<String> getTerminal() =>
      CacheStorageHandler.instance.read(CacheKeys.terminals);
}
