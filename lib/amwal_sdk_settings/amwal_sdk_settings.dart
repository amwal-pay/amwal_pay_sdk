import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

abstract class IAmwalSdkSettings {
  final String token;
  String? secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String transactionId;
  final Locale locale;
  final bool isMocked;
  final String amount;
  final String currency;
  final String? merchantName;
  final String? flavor;

  final OnPayCallback onPay;
  final OnPayCallback? onCountComplete;
  final GetTransactionFunction? getTransactionFunction;
  final void Function(Object e, StackTrace stack)? onError;
  final Future<String?> Function()? onTokenExpired;
  final int countDownInSeconds;

    IAmwalSdkSettings({
    required this.token,
    this.secureHashValue,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.onPay,
    this.countDownInSeconds = 90,
    this.getTransactionFunction,
    this.onError,
    this.onCountComplete,
    this.merchantName,
    this.flavor,
    this.locale = const Locale('en'),
    this.isMocked = false,
    this.onTokenExpired,
  });
}

class AmwalInAppSdkSettings extends IAmwalSdkSettings {
  AmwalInAppSdkSettings(
      {required super.token,
      super.secureHashValue,
      required super.merchantId,
      required super.terminalIds,
      required super.transactionId,
      required super.merchantName,
      required super.onPay,
      super.getTransactionFunction,
      super.countDownInSeconds = 90,
      super.onCountComplete,
      super.locale,
      super.isMocked,
      super.onError,
      super.onTokenExpired,
      super.flavor})
      : super(
          amount: '',
          currency: '',
        );

  factory AmwalInAppSdkSettings.fromJson(Map<String, dynamic> json) {
    return AmwalInAppSdkSettings(
      token: json['token'],
      secureHashValue: json['secureHashValue'],
      merchantId: json['merchantId'],
      terminalIds: json['terminalIds'] ?? [],
      transactionId: json['transactionId'],
      merchantName: json['merchantName'],
      onPay: json['onPay'],
      countDownInSeconds: json['countDownInSeconds'],
      getTransactionFunction: json['getTransactionFunction'],
      onError: json['onError'],
      onCountComplete: json['onCountComplete'],
      locale: json['locale'],
      isMocked: json['isMocked'],
      onTokenExpired: json['onTokenExpired'],
      flavor: json['flavor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'secureHashValue': secureHashValue,
      'merchantId': merchantId,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'merchantName': merchantName,
      'locale': locale,
      'isMocked': isMocked,
      'countDownInSeconds': countDownInSeconds,
      'flavor': flavor,
    };
  }
}

class AmwalSdkSettings extends IAmwalSdkSettings {
  final String terminalId;

  AmwalSdkSettings(
      {super.token = '',
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
      super.countDownInSeconds = 90,
      super.flavor})
      : super(terminalIds: [terminalId], onPay: (_, [__]) {});

  factory AmwalSdkSettings.fromJson(Map<String, dynamic> json) {
    return AmwalSdkSettings(
      token: json['token'] ?? '',
      secureHashValue: json['secureHashValue'],
      merchantId: json['merchantId'],
      transactionId: json['transactionId'],
      currency: json['currency'],
      amount: json['amount'],
      terminalId: json['terminalId'],
      merchantName: json['merchantName'],
      getTransactionFunction: null,
      // You should handle this according to your logic
      onCountComplete: null,
      // You should handle this according to your logic
      locale: json['locale'],
      isMocked: json['isMocked'],
      onError: null,
      // You should handle this according to your logic
      onTokenExpired: null,
      // You should handle this according to your logic
      countDownInSeconds: json['countDownInSeconds'] ?? 90,
      flavor: json['flavor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'secureHashValue': secureHashValue,
      'merchantId': merchantId,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'terminalId': terminalId,
      'merchantName': merchantName,
      'locale': locale,
      'isMocked': isMocked,
      'countDownInSeconds': countDownInSeconds,
      'flavor': flavor,
    };
  }
}
