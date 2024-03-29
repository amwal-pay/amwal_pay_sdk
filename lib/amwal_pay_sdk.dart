library amwal_pay_sdk;

import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/wallet/amwal_salebywallet_sdk.dart';
import 'package:amwal_pay_sdk/sdk_builder/network_service_builder.dart';

export 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';

class AmwalPaySdk {
  const AmwalPaySdk._();

  static AmwalPaySdk get instance => const AmwalPaySdk._();

  Future<bool> initSdk({
    required AmwalSdkSettings settings,
  }) async {
    await _initWalletSdk(settings: settings);
    await _initCardSdk(settings: settings);
    return true;
  }

  Future<AmwalWalletSdk> _initWalletSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final service = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.requestSourceId,
    );
    return await AmwalWalletSdk.instance.init(
      merchantName: settings.merchantName,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      requestSourceId: settings.requestSourceId,
      isMocked: settings.isMocked,
      locale: settings.locale,
      service: service,
    );
  }

  Future<AmwalCardSdk> _initCardSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final service = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.requestSourceId,
      // settings.apiKey,
    );

    return await AmwalCardSdk.instance.init(
      merchantName: settings.merchantName,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      requestSourceId: settings.requestSourceId,
      isMocked: settings.isMocked,
      locale: settings.locale,
      service: service,
    );
  }

  Future<void> openWalletScreen(AmwalInAppSdkSettings settings) async {
    final walletSdk = await _initWalletSdk(settings: settings);
    await walletSdk.navigateToWallet(
      settings.locale,
      settings.merchantName,
      settings.merchantId,
    );
  }

  Future<void> openCardScreen(AmwalInAppSdkSettings settings) async {
    final cardSdk = await _initCardSdk(settings: settings);
    await cardSdk.navigateToCard(
      settings.locale,
      settings.merchantName,
      settings.merchantId,
    );
  }
}
