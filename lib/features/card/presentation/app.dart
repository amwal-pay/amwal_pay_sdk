import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_screen.dart';
import 'package:amwal_pay_sdk/localization/app_localizations_setup.dart';
import 'package:flutter/material.dart';

class CardSdkApp extends StatelessWidget {
  final Locale? locale;
  final int merchantId;
  final String merchantName;
  // final OnPayCallback onPay;
  const CardSdkApp({
    Key? key,
    required this.locale,
    required this.merchantId,
    required this.merchantName,
    // required this.onPay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
      locale: locale ?? const Locale('en'),
      home: SaleByCardScreen(
        merchantId: merchantId,
        merchantName: merchantName,
        locale: locale ?? const Locale('en'),
        // onPay: onPay,
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
