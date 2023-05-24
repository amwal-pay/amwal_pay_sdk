import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:flutter/material.dart';

class AmwalSdkArguments {
  final Locale locale;
  final bool is3DS;
  final String amount;
  final String terminalId;
  final String? transactionId;
  final String currency;
  final int currencyId;
  final int merchantId;
  final void Function(void Function(TransactionDetailsSettings) listener) onMessage;

  AmwalSdkArguments({
    required this.onMessage,
    this.locale = const Locale('en'),
    this.is3DS = false,
    required this.amount,
    required this.terminalId,
    required this.currency,
    required this.currencyId,
    required this.merchantId,
    this.transactionId,
  });
}
