import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
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
  final OnPayCallback onPay;
  final OnPayCallback? onCountComplete;
  final void Function(Object e, StackTrace stack)? onError;
  final Future<String?> Function()? onTokenExpired;

  const IAmwalSdkSettings({
    required this.token,
    required this.secureHashValue,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.onPay,
    this.onError,
    this.onCountComplete,
    this.merchantName,
    this.locale = const Locale('en'),
    this.is3DS = false,
    this.isMocked = false,
    this.onTokenExpired,
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
    required super.onPay,
    super.onCountComplete,
    super.locale,
    super.is3DS,
    super.isMocked,
    super.onError,
    super.onTokenExpired,
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
    super.onCountComplete,
    super.locale,
    super.isMocked,
    super.is3DS,
    super.onError,
    super.onTokenExpired,
  }) : super(terminalIds: [terminalId], onPay: (_, [__]) {});
}
