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
    String token,
    List<String> terminalIds,
    String? secureHashValue,
    String merchantId,
    bool isMocked,
    service, {
    String? merchantName,
    Locale? locale,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write(CacheKeys.token, token);
    await CacheStorageHandler.instance.write(CacheKeys.terminals, terminalIds);
    await CacheStorageHandler.instance.write(
      CacheKeys.merchantId,
      merchantId,
    );
    await CacheStorageHandler.instance.write(
      CacheKeys.merchantName,
      merchantName,
    );
    SdkBuilder.instance.initWalletModules(service);
  }

  Future<AmwalWalletSdk> init({
    required String token,
    required String merchantId,
    required List<String> terminalIds,
    String? secureHashValue,
    required String transactionRefNo,
    required NetworkService service,
    String? merchantName,
    bool isMocked = false,
    Locale? locale,
  }) async {
    await WalletInjector.instance.onSdkInit(
      () async => await _sdkInitialization(
        token,
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
    OnPayCallback onPay,
    OnPayCallback onCountComplete,
    GetTransactionFunction getTransactionFunction,
    String transactionId,
    int countDownInSeconds,
    EventCallback? log,
  ) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(
      MaterialPageRoute(
        builder: (_) => WalletSdkApp(
          locale: locale,
          onPay: onPay,
          onCountComplete: onCountComplete,
          transactionId: transactionId,
          getTransactionFunction: getTransactionFunction,
          countDownInSeconds: countDownInSeconds,
          log: log,
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
