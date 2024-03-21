import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

abstract class IAmwalSdkSettings {
  final String token;
  final String secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String transactionId;
  final Locale locale;
  final bool isMocked;
  final String amount;
  final String currency;
  final String? merchantName;
  final OnPayCallback onPay;
  final OnPayCallback? onCountComplete;
  final GetTransactionFunction? getTransactionFunction;
  final void Function(Object e, StackTrace stack)? onError;
  final Future<String?> Function()? onTokenExpired;
  final int countDownInSeconds;

  const IAmwalSdkSettings({
    required this.token,
    required this.secureHashValue,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.onPay,
    this.countDownInSeconds = 30,
    this.getTransactionFunction,
    this.onError,
    this.onCountComplete,
    this.merchantName,
    this.locale = const Locale('en'),
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
    super.getTransactionFunction,
    super.countDownInSeconds = 30,
    super.onCountComplete,
    super.locale,
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
    super.token = '',
    required super.secureHashValue,
    required super.merchantId,
    required super.transactionId,
    required super.currency,
    required super.amount,
    required this.terminalId,
    super.merchantName,
    super.getTransactionFunction,
    super.onCountComplete,
    super.locale,
    super.isMocked,
    super.onError,
    super.onTokenExpired,
    super.countDownInSeconds = 30,
  }) : super(terminalIds: [terminalId], onPay: (_, [__]) {});
}
