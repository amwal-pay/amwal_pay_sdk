library amwal_pay_sdk;

import 'dart:io';

import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/networking/network_service.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/wallet/amwal_salebywallet_sdk.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:amwal_pay_sdk/presentation/amwal_pay_screen.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:amwal_pay_sdk/sdk_builder/network_service_builder.dart';
import 'package:amwal_pay_sdk/sdk_builder/sdk_builder.dart';
import 'package:flutter/material.dart';

import 'core/ui/error_dialog.dart';
import 'core/ui/loading_dialog.dart';
import 'features/transaction/data/repository/transaction_repository_impl.dart';
import 'localization/app_localizations_setup.dart';

export 'package:amwal_pay_sdk/features/receipt/receipt_handler.dart';
export 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';

class AmwalPaySdk {
  const AmwalPaySdk._();

  static AmwalPaySdk get instance => const AmwalPaySdk._();

  Future<void> initSdk({
    required AmwalSdkSettings settings,
  }) async {
    AmwalSdkSettingContainer.locale = settings.locale;
    NetworkConstants.isSdkInApp = true;
    await SdkBuilder.instance.initCacheStorage();
    await CacheStorageHandler.instance.write(
      CacheKeys.token,
      settings.token,
    );
    await CacheStorageHandler.instance.write(
      CacheKeys.terminals,
      settings.terminalIds,
    );
    await CacheStorageHandler.instance.write(
      CacheKeys.merchantId,
      settings.merchantId,
    );
    await CacheStorageHandler.instance.write(
      CacheKeys.merchantName,
      settings.merchantName,
    );

    HttpOverrides.global = MyHttpOverrides();
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.token,
      settings.locale.languageCode,
    );

    SdkBuilder.instance.initSdkModules(networkService);

    checkMerchantProvidedData(networkService, settings);
  }

  void checkMerchantProvidedData(
      NetworkService networkService, AmwalSdkSettings settings) {
    var transactionRepo = TransactionRepositoryImpl(networkService);

    var map = {
      "merchantId": settings.merchantId,
      "terminalId": settings.terminalId,
    };

    transactionRepo.getMerchantName(map).then((value) {
      value.when(
        success: (data) async {
          await CacheStorageHandler.instance.write(
            CacheKeys.merchantName,
            data.data,
          );
          await _openAmwalSdkScreen(
            settings,
          );
        },
        initial: () {
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(
            DialogRoute(
              context:
                  AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
              builder: (_) => const LoadingDialog(),
            ),
          );
          //loading state
        },
        error: (String? message, List<String>? errorList) {
          settings.onError
              ?.call(errorList?.first ?? message ?? '', StackTrace.current);

          if (AmwalSdkNavigator.amwalNavigatorObserver.navigator != null) {
            final context =
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context;
            return showDialog(
              context: context,
              builder: (_) => Localizations(
                locale: AmwalSdkSettingContainer.locale,
                delegates: const [
                  ...AppLocalizationsSetup.localizationsDelegates
                ],
                child: ErrorDialog(
                  title: message ?? '',
                  message: (errorList?.join(',') ??
                      errorList?.toString() ??
                      'something_went_wrong'.translate(context)),
                  resetState: () {
                    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                  },
                ),
              ),
            );
          }
          // back to previous screen
          // AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
        },
      );
    });
  }

  Future<AmwalWalletSdk> _initWalletSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.token,
      settings.locale.languageCode,
      onError: settings.onError,
      onTokenExpired: settings.onTokenExpired,
    );
    return await AmwalWalletSdk.instance.init(
      token: settings.token,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      transactionRefNo: settings.transactionId,
      isMocked: settings.isMocked,
      service: networkService,
      locale: settings.locale,
      merchantName: settings.merchantName,
    );
  }

  Future<AmwalCardSdk> _initCardSdk({
    required IAmwalSdkSettings settings,
  }) async {
    final networkService = NetworkServiceBuilder.instance.setupNetworkService(
      settings.isMocked,
      settings.secureHashValue,
      settings.token,
      settings.locale.languageCode,
      onError: settings.onError,
      onTokenExpired: settings.onTokenExpired,
    );
    return await AmwalCardSdk.instance.init(
      token: settings.token,
      merchantId: settings.merchantId,
      terminalIds: settings.terminalIds,
      secureHashValue: settings.secureHashValue,
      transactionRefNo: settings.transactionId,
      isMocked: settings.isMocked,
      service: networkService,
      locale: settings.locale,
      merchantName: settings.merchantName,
    );
  }

  Future<void> openWalletScreen(AmwalInAppSdkSettings settings) async {
    final walletSdk = await _initWalletSdk(settings: settings);
    await walletSdk.navigateToWallet(
      settings.locale,
      settings.onPay,
      settings.onCountComplete ?? (_, [__]) {},
      settings.getTransactionFunction ?? (_) async => null,
      settings.transactionId,
      settings.countDownInSeconds,
    );
  }

  Future<void> openCardScreen(AmwalInAppSdkSettings settings) async {
    final cardSdk = await _initCardSdk(settings: settings);
    await cardSdk.navigateToCard(
      settings.locale,
      settings.transactionId,
      settings.onPay,
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
            theme: ThemeData(
              useMaterial3: false,
            ),
            home: AmwalPayScreen(
              arguments: AmwalSdkArguments(
                onPay: settings.onPay,
                amount: settings.amount,
                terminalId: settings.terminalIds.single,
                currency: settings.currency,
                transactionId: settings.transactionId,
                currencyId: 512,
                merchantId: int.parse(settings.merchantId),
                getTransactionFunction:
                    settings.getTransactionFunction ?? (_) async => null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
