library amwal_pay_sdk;

import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/wallet/amwal_salebywallet_sdk.dart';
import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:amwal_pay_sdk/presentation/amwal_pay_screen.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/sdk_builder/network_service_builder.dart';
import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';
import 'package:flutter/material.dart';

import 'localization/app_localizations_setup.dart';

export 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';

class AmwalPaySdk {
  const AmwalPaySdk._();

  static AmwalPaySdk get instance => const AmwalPaySdk._();

  Future<void> initSdk({
    required AmwalSdkSettings settings,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write('token', settings.token);
    await CacheStorageHandler.instance.write('terminal', settings.terminalIds);
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.requestSourceId,
      settings.token,
    );
    SdkBuilder.instance.initSdkModules(networkService);
    await _openAmwalSdkScreen(
      settings,
    );
  }

  Future<AmwalWalletSdk> _initWalletSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
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
      service: networkService,
      locale: settings.locale,
    );
  }

  Future<AmwalCardSdk> _initCardSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
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
      service: networkService,
      locale: settings.locale,
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

  Future<void> _openAmwalSdkScreen(AmwalSdkSettings settings) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(
      MaterialPageRoute(
        builder: (_) {
          return MaterialApp(
            localeResolutionCallback:
                AppLocalizationsSetup.localeResolutionCallback,
            localizationsDelegates:
                AppLocalizationsSetup.localizationsDelegates,
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            debugShowCheckedModeBanner: false,
            locale: settings.locale,
            home: AmwalPayScreen(
              arguments: AmwalSdkArguments(
                amount: settings.amount,
                terminalId: settings.terminalIds.single,
                currency: settings.currency,
                currencyId: 512,
              ),
            ),
          );
        },
      ),
    );
  }
}
