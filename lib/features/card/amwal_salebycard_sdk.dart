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
    List<String> terminalIds,
    String secureHashValue,
    int merchantId,
    bool isMocked,
    NetworkService service, {
    Locale? locale,
    String? merchantName,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write('terminal', terminalIds);
    SdkBuilder.instance.initCardModules(service);
  }

  Future<AmwalCardSdk> init({
    required int merchantId,
    required List<String> terminalIds,
    required String secureHashValue,
    required String requestSourceId,
    required NetworkService service,
    String? merchantName,
    bool isMocked = false,
    bool is3DS = false,
    Locale? locale,
  }) async {
    await CardInjector.instance.onSdkInit(
      () async => await _sdkInitialization(
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
    String merchantName,
    int merchantId,
  ) async {
    await AmwalSdkNavigator.instance.toCardScreen(
      locale: locale,
      merchantName: merchantName,
      merchantId: merchantId,
    );
  }
}
