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
    // await _openAmwalSdkScreen(
    //   settings,
    // );
  }

  Future<AmwalWalletSdk> _initWalletSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final service = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.requestSourceId,
      settings.token,
    );
    return await AmwalWalletSdk.instance.init(
      token: settings.token,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      requestSourceId: settings.requestSourceId,
      transactionRefNo: settings.transactionRefNo,
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
      settings.token,
    );

    return await AmwalCardSdk.instance.init(
      token: settings.token,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      requestSourceId: settings.requestSourceId,
      transactionRefNo: settings.transactionRefNo,
      isMocked: settings.isMocked,
      locale: settings.locale,
      service: service,
    );
  }

  Future<void> openWalletScreen(AmwalInAppSdkSettings settings) async {
    final walletSdk = await _initWalletSdk(settings: settings);
    await walletSdk.navigateToWallet(
      settings.locale,
    );
  }

  Future<void> openCardScreen(AmwalInAppSdkSettings settings) async {
    final cardSdk = await _initCardSdk(settings: settings);
    await cardSdk.navigateToCard(
      settings.locale,
      settings.is3DS,
    );
  }
}
