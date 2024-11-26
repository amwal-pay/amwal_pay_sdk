import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/card/module/sale_by_card_module.dart';
import 'package:amwal_pay_sdk/features/currency_field/module/currency_binds.dart';
import 'package:amwal_pay_sdk/features/transaction/module/transaction_module.dart';
import 'package:amwal_pay_sdk/features/wallet/module/sale_by_wallet_module.dart';
import 'package:get_storage/get_storage.dart';

class SdkBuilder {
  const SdkBuilder._();
  static SdkBuilder get instance => const SdkBuilder._();

  Future<void> initCacheStorage() async =>
      await CacheStorageHandler.instance.init();

  void initTransactionModule(NetworkService networkService) {}

  void initCardModules(NetworkService networkService) {
    final currencyModule = CurrencyBinds(networkService);
    final cardModule = SaleByCardModule(networkService);
    final transactionModule = TransactionModule.card(networkService);
    transactionModule.setup();
    currencyModule.setup();
    cardModule.setup();
  }

  void initWalletModules(NetworkService networkService) {
    final currencyModule = CurrencyBinds(networkService);
    final walletModule = SaleByWalletModule(networkService);
    final transactionModule = TransactionModule.wallet(networkService);
    transactionModule.setup();
    currencyModule.setup();
    walletModule.setup();
  }

  void initSdkModules(NetworkService networkService) {
    final cardModule = SaleByCardModule(networkService);
    final walletModule = SaleByWalletModule(networkService);
    final currencyModule = CurrencyBinds(networkService);
    final transactionModule = TransactionModule.both(networkService);
    transactionModule.setup();
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

class CacheKeys {
  const CacheKeys._();
  static const merchantId = 'amwal_pay_sdk_merchant_id';
  static const merchantData = 'amwal_pay_sdk_merchant_data';
  static const merchantName = 'amwal_pay_sdk_merchant_name';
  static const merchant_flavor = 'merchant_flavor';
  static const token = 'amwal_pay_sdk_merchant_token';
  static const terminals = 'amwal_pay_sdk_merchant_terminals';
  static const sessionToken = 'amwal_pay_sdk_session_token';
}
