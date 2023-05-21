import 'package:flutter/material.dart';

abstract class IAmwalSdkSettings {
  final String token;
  final String secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String transactionId;
  final Locale locale;
  final bool is3DS;
  final bool isMocked;
  final String amount;
  final String currency;
  final String? merchantName;

  const IAmwalSdkSettings({
    required this.token,
    required this.secureHashValue,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionId,
    required this.currency,
    required this.amount,
    this.merchantName,
    this.locale = const Locale('en'),
    this.is3DS = false,
    this.isMocked = false,
  });
}

class AmwalInAppSdkSettings extends IAmwalSdkSettings {
  const AmwalInAppSdkSettings({
    required super.token,
    required super.secureHashValue,
    required super.merchantId,
    required super.terminalIds,
    required super.transactionId,
    required super.merchantName,
    super.locale,
    super.is3DS,
    super.isMocked,
  }) : super(
          amount: '',
          currency: '',
        );
}

class AmwalSdkSettings extends IAmwalSdkSettings {
  final String terminalId;

  AmwalSdkSettings({
    required super.token,
    required super.secureHashValue,
    required super.merchantId,
    required super.transactionId,
    required super.currency,
    required super.amount,
    required this.terminalId,
    required super.merchantName,
    super.locale,
    super.isMocked,
    super.is3DS,
  }) : super(
          terminalIds: [terminalId],
        );
}
