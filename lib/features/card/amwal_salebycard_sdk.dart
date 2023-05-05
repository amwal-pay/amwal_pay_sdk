library amwal_salebycard_sdk;

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/networking/dio_client.dart';
import 'package:amwal_pay_sdk/core/networking/mockup_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/core/networking/secure_hash_interceptor.dart';
import 'package:amwal_pay_sdk/core/networking/token_interceptor.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';

import 'package:flutter/material.dart';

export 'dependency/injector.dart';

class AmwalCardSdk {
  const AmwalCardSdk._();
  static AmwalCardSdk get instance => const AmwalCardSdk._();

  Future<void> _sdkInitialization(
    String token,
    List<String> terminalIds,
    String secureHashValue,
    String requestSourceId,
    bool isMocked,
    NetworkService service, {
    Locale? locale,
  }) async {
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write('token', token);
    await CacheStorageHandler.instance.write('terminal', terminalIds);
    SdkBuilder.instance.initCardModules(service);
  }

  Future<AmwalCardSdk> init({
    required String token,
    required String merchantId,
    required List<String> terminalIds,
    required String secureHashValue,
    required String requestSourceId,
    required String transactionRefNo,
    required NetworkService service,
    bool isMocked = false,
    bool is3DS = false,
    Locale? locale,
  }) async {
    await CardInjector.instance.onSdkInit(
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

  Future<void> navigateToCard(
    Locale locale,
    bool is3DS,
  ) async {
    await AmwalSdkNavigator.instance.toCardScreen(
      is3DS: is3DS,
      locale: locale,
    );
  }
}
