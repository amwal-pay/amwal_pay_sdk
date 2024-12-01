import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:flutter/material.dart';

typedef OnPayCallback = void Function(
    void Function(TransactionDetailsSettings) listener,
    [String? transactionId]);

typedef GetTransactionFunction = Future<TransactionDetailsSettings?> Function(
    String transactionId);

typedef EventCallback = void Function(
  String event,
  Map<String, dynamic> param,
);

class AmwalSdkArguments {
  final Locale locale;
  final bool is3DS;
  final String amount;
  final String terminalId;
  final String? transactionId;
  final String currency;
  final int currencyId;
  final int merchantId;
  final OnPayCallback onPay;
  final OnPayCallback? onCountComplete;
  final GetTransactionFunction getTransactionFunction;
  final void Function(String?)? customerCallback;
  final String? customerId;

  AmwalSdkArguments({
    this.customerId,
    this.customerCallback,
    required this.getTransactionFunction,
    required this.onPay,
    this.onCountComplete,
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
