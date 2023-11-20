import 'package:flutter/material.dart';

class AmwalSdkArguments {
  final Locale locale;
  final String amount;
  final String terminalId;
  final String currency;
  final int currencyId;
  final String merchantName;
  final int merchantId;

  const AmwalSdkArguments({
    this.locale = const Locale('en'),
    required this.amount,
    required this.terminalId,
    required this.currency,
    required this.currencyId,
    required this.merchantName,
    required this.merchantId,
  });
}
