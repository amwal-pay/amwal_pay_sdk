
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/card/module/sale_by_card_module.dart';
import 'package:amwal_pay_sdk/features/currency_field/module/currency_binds.dart';
import 'package:amwal_pay_sdk/features/wallet/module/sale_by_wallet_module.dart';
import 'package:get_storage/get_storage.dart';

class SdkBuilder {
  const SdkBuilder._();
  static SdkBuilder get instance => const SdkBuilder._();

  Future<void> initCacheStorage() async =>
      await CacheStorageHandler.instance.init();


  void initCardModules(NetworkService networkService){
    final currencyModule = CurrencyBinds(networkService);
    final cardModule = SaleByCardModule(networkService);
    currencyModule.setup();
    cardModule.setup();
  }
  void initWalletModules(NetworkService networkService){
    final currencyModule = CurrencyBinds(networkService);
    final walletModule = SaleByWalletModule(networkService);
    currencyModule.setup();
    walletModule.setup();
  }

  void initSdkModules(NetworkService networkService) {
    final cardModule = SaleByCardModule(networkService);
    final walletModule = SaleByWalletModule(networkService);
    final currencyModule = CurrencyBinds(networkService);
    currencyModule.setup();
    walletModule.setup();
    cardModule.setup();
  }
}

class CacheStorageHandler {
  const CacheStorageHandler._();
  static CacheStorageHandler get instance => const CacheStorageHandler._();

  GetStorage get _getStorage => GetStorage();

  Future<void> init() async {
    await GetStorage.init();
  }

  Future<void> write(String key, dynamic value) async =>
      await _getStorage.write(key, value);

  T? read<T>(String key) => _getStorage.read<T>(key);
}
