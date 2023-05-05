import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';

class MerchantStore {
  const MerchantStore._();
  static MerchantStore get instance => const MerchantStore._();

  String getToken() => CacheStorageHandler.instance.read('token');

  List<String> getTerminal() => CacheStorageHandler.instance.read('terminal');
}
