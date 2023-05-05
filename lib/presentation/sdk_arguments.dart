import 'package:flutter/material.dart';

class AmwalSdkArguments {
  final Locale locale;
  final bool is3DS;
  final String amount;
  final String terminalId;
  final String currency;
  final int currencyId;

  AmwalSdkArguments({
    this.locale = const Locale('en'),
    this.is3DS = false,
    required this.amount,
    required this.terminalId,
    required this.currency,
    required this.currencyId,
  });
}
