import 'package:amwal_pay_sdk/features/card/presentation/app.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_manual_screen.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_paying_options.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

class AmwalSdkNavigator {
  const AmwalSdkNavigator._();

  static AmwalSdkNavigator get instance => const AmwalSdkNavigator._();

  static NavigatorObserver amwalNavigatorObserver = NavigatorObserver();

  Future<void> toWalletOptionsScreen(
    BuildContext context,
    RouteSettings settings,
    OnPayCallback onPay,
    OnPayCallback onCountComplete,
    GetTransactionFunction getTransactionFunction,

  ) async {
    final args = settings.arguments as PaymentArguments;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SaleByWalletPayingOptions(
          getTransactionFunction: getTransactionFunction,
          onCountComplete: onCountComplete,
          onPay: onPay,
          amount: args.amount,
          terminalId: args.terminalId,
          merchantId: args.merchantId,
          currencyId: args.currencyData!.idN,
          currency: args.currencyData!.name,
          transactionId: args.transactionId,
        ),
      ),
    );
  }

  Future<void> toCardScreen({
    Locale? locale,
    String? transactionId,
    required bool is3DS,
    required OnPayCallback onPay,
  }) async =>
      await amwalNavigatorObserver.navigator!.push(
        MaterialPageRoute(
          builder: (_) => CardSdkApp(
            locale: locale,
            is3DS: is3DS,
            transactionId: transactionId,
            onPay: onPay,
          ),
        ),
      );

  Future<void> toCardOptionScreen(
    RouteSettings settings,
    BuildContext context,
    Locale locale,
    OnPayCallback onPay,
  ) async {
    final arguments = settings.arguments as PaymentArguments;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SaleByCardManualScreen(
          onPay: onPay,
          locale: locale,
          currency: arguments.currencyData!.name,
          currencyId: arguments.currencyData!.idN,
          terminalId: arguments.terminalId,
          amount: arguments.amount,
          is3DS: arguments.is3DS,
          merchantId: arguments.merchantId,
          transactionId: arguments.transactionId,
        ),
        settings: settings,
      ),
    );
  }
}
