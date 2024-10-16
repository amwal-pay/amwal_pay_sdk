library amwal_salebycard_sdk;

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';
import 'package:flutter/material.dart';

export 'dependency/injector.dart';

class AmwalCardSdk {
  const AmwalCardSdk._();

  static AmwalCardSdk get instance => const AmwalCardSdk._();

  Future<void> _sdkInitialization(
    String token,
    List<String> terminalIds,
    String? secureHashValue,
    String merchantId,
    bool isMocked,
    NetworkService service, {
    Locale? locale,
    String? merchantName,
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
    SdkBuilder.instance.initCardModules(service);
  }

  Future<AmwalCardSdk> init({
    required String token,
    required String merchantId,
    required List<String> terminalIds,
      String? secureHashValue,
    required String transactionRefNo,
    required NetworkService service,
    String? merchantName,
    bool isMocked = false,
    bool is3DS = false,
    Locale? locale,
  }) async {
    await CardInjector.instance.onSdkInit(
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

  Future<void> navigateToCard(
    Locale locale,
    String transactionId,
    OnPayCallback onPay,
  ) async {
    await AmwalSdkNavigator.instance.toCardScreen(
      locale: locale,
      transactionId: transactionId,
      onPay: onPay,
    );
  }
}
