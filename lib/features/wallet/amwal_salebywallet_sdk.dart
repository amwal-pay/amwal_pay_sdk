library amwal_pay_sdk;

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';

import 'package:amwal_pay_sdk/core/networking/network_service.dart';

import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/app.dart';


import 'package:flutter/material.dart';

import '../../sdk_builder/sdk_builder.dart';



class AmwalWalletSdk {
  const AmwalWalletSdk._();
  static AmwalWalletSdk get instance => const AmwalWalletSdk._();


  Future<void> _sdkInitialization(
    String token,
    List<String> terminalIds,
    String secureHashValue,
    String requestSourceId,
    bool isMocked,
      service,{
    Locale? locale,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write('token', token);
    await CacheStorageHandler.instance.write('terminal', terminalIds);
    SdkBuilder.instance.initWalletModules(service);
  }

  Future<AmwalWalletSdk> init({
    required String token,
    required String merchantId,
    required List<String> terminalIds,
    required String secureHashValue,
    required String requestSourceId,
    required String transactionRefNo,
    required NetworkService service,
    bool isMocked = false,
    Locale? locale,
  }) async {
    await WalletInjector.instance.onSdkInit(
      () async => await _sdkInitialization(
        token,
        terminalIds,
        secureHashValue,
        requestSourceId,
        isMocked,
        service,
        locale: locale,
      ),
    );
    return this;
  }

  Future<void> navigateToWallet(
    Locale locale,
  ) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(
      MaterialPageRoute(
        builder: (_) => WalletSdkApp(
          locale: locale,
        ),
      ),
    );
  }
}

class AmwalWalletSettings {
  final String token;
  final List<String> terminalIds;
  final String secureHashValue;
  final String requestSourceId;
  final bool isMocked;
  final Locale locale;
  final NavigatorObserver navigatorObserver;

  AmwalWalletSettings({
    required this.token,
    required this.terminalIds,
    required this.secureHashValue,
    required this.requestSourceId,
    required this.isMocked,
    required this.locale,
    required this.navigatorObserver,
  });
}
