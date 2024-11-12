import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_screen.dart';
import 'package:amwal_pay_sdk/localization/app_localizations_setup.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

class CardSdkApp extends StatelessWidget {
  final Locale? locale;
  final String? transactionId;
  final OnPayCallback onPay;
  final EventCallback? log;
  const CardSdkApp({
    Key? key,
    this.transactionId,
    required this.locale,
    required this.onPay,
    this.log,
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
        transactionId: transactionId,
        locale: locale ?? const Locale('en'),
        onPay: onPay,
        log: log,
      ),
      theme: ThemeData(
        useMaterial3: false,
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
