library amwal_pay_sdk;

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/app.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

import '../../sdk_builder/sdk_builder.dart';

class AmwalWalletSdk {
  const AmwalWalletSdk._();
  static AmwalWalletSdk get instance => const AmwalWalletSdk._();

  Future<void> _sdkInitialization(
    List<String> terminalIds,
    String secureHashValue,
    int merchantId,
    bool isMocked,
    service, {
    String? merchantName,
    Locale? locale,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write('terminal', terminalIds);
    SdkBuilder.instance.initWalletModules(service);
  }

  Future<AmwalWalletSdk> init({
    required int merchantId,
    required List<String> terminalIds,
    required String secureHashValue,
    required String requestSourceId,
    required NetworkService service,
    String? merchantName,
    bool isMocked = false,
    Locale? locale,
  }) async {
    await WalletInjector.instance.onSdkInit(
      () async => await _sdkInitialization(
        // token,
        terminalIds,
        secureHashValue,
        merchantId,
        isMocked,
        service,
        locale: locale,
        merchantName: merchantName,
      ),
    );
    return this;
  }

  Future<void> navigateToWallet(
    Locale locale,
    String merchantName,
    int merchantId,
  ) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(
      MaterialPageRoute(
        builder: (_) => WalletSdkApp(
          locale: locale,
          merchantId: merchantId,
          merchantName: merchantName,
        ),
      ),
    );
  }
}

class AmwalWalletSettings {
  final String token;
  final List<String> terminalIds;
  final String secureHashValue;
  final bool isMocked;
  final Locale locale;
  final NavigatorObserver navigatorObserver;

  AmwalWalletSettings({
    required this.token,
    required this.terminalIds,
    required this.secureHashValue,
    required this.isMocked,
    required this.locale,
    required this.navigatorObserver,
  });
}
