import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_screen.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_by_wallet_mixins/sale_by_wallet_action_mixin.dart';
import 'package:amwal_pay_sdk/localization/app_localizations_setup.dart';
import 'package:flutter/material.dart';

class WalletSdkApp extends StatelessWidget {
  final Locale? locale;
  final OnWalletNotificationReceived onWalletNotificationReceived;
  const WalletSdkApp(
      {Key? key,
      required this.locale,
      required this.onWalletNotificationReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
      locale: locale ?? const Locale('en'),
      home: SaleByWalletScreen(
        onWalletNotificationReceived: onWalletNotificationReceived,
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: blackColor,
          iconTheme: IconThemeData(color: blackColor),
          centerTitle: true,
          elevation: 0,
        ),
      ),
    );
  }
}
