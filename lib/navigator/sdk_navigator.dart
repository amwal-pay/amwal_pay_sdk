import 'package:amwal_pay_sdk/features/card/presentation/app.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_manual_screen.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_paying_options.dart';
import 'package:flutter/material.dart';

class AmwalSdkNavigator {
  const AmwalSdkNavigator._();
  static AmwalSdkNavigator get instance => const AmwalSdkNavigator._();

  static NavigatorObserver amwalNavigatorObserver = NavigatorObserver();

  Future<void> toWalletOptionsScreen(
    BuildContext context,
    RouteSettings settings,
  ) async {
    final args = settings.arguments as PaymentArguments;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SaleByWalletPayingOptions(
          merchantId: args.merchantId,
          amount: args.amount,
          terminalId: args.terminalId,
          currencyId: args.currencyData!.idN,
          currency: args.currencyData!.name,
          merchantName: args.merchantName,
        ),
      ),
    );
  }

  Future<void> toCardScreen({
    Locale? locale,
    required String merchantName,
    required int merchantId,
  }) async =>
      await amwalNavigatorObserver.navigator!.push(
        MaterialPageRoute(
          builder: (_) => CardSdkApp(
            locale: locale,
            merchantName: merchantName,
            merchantId: merchantId,
          ),
        ),
      );

  Future<void> toCardOptionScreen(
    RouteSettings settings,
    BuildContext context,
    Locale locale,
  ) async {
    final arguments = settings.arguments as PaymentArguments;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SaleByCardManualScreen(
          locale: locale,
          merchantId: arguments.merchantId,
          currency: arguments.currencyData!.name,
          currencyId: arguments.currencyData!.idN,
          terminalId: arguments.terminalId,
          amount: arguments.amount,
          merchantName: arguments.merchantName,
        ),
        settings: settings,
      ),
    );
  }
}
