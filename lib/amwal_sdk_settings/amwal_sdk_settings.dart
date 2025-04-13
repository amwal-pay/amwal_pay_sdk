import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/enums/transaction_type.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:amwal_pay_sdk/core/logger/amwal_logger.dart';

abstract class IAmwalSdkSettings {
  final String token;
  String? secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String transactionId;
  final Locale locale;
  final bool isMocked;
  final TransactionType transactionType;
  final String amount;
  final String currency;
  final String? merchantName;
  final String? flavor;
  final double? maxTransactionAmount;
  final String sessionToken;
  final AmwalLoggerFunction? logger;

  Environment? environment = Environment.PROD;

  final OnPayCallback onPay;
  final OnPayCallback? onCountComplete;
  final GetTransactionFunction? getTransactionFunction;
  final void Function(Object e, StackTrace stack)? onError;
  final void Function(String, Map<String, dynamic> param)? log;
  final Future<String?> Function()? onTokenExpired;
  final int countDownInSeconds;
  final void Function(String?)? customerCallback;
  final String? customerId;
  final void Function(String?)? onResponse;

  bool get isSoftPOS => transactionType.isSoftPOS;

  IAmwalSdkSettings({
    this.onResponse,
    this.customerId,
    this.customerCallback,
    required this.sessionToken,
    required this.token,
    this.secureHashValue,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionId,
    required this.currency,
    required this.amount,
    required this.onPay,
    this.countDownInSeconds = 90,
    this.maxTransactionAmount = 5000,
    this.getTransactionFunction,
    this.onError,
    this.onCountComplete,
    this.merchantName,
    this.logger,
    this.flavor,
    this.locale = const Locale('en'),
    this.isMocked = false,
    this.transactionType = TransactionType.cardWallet,
    this.onTokenExpired,
    this.log,
    this.environment,
  });
}

class AmwalInAppSdkSettings extends IAmwalSdkSettings {
  AmwalInAppSdkSettings({
    required super.token,
    super.secureHashValue,
    required super.merchantId,
    required super.terminalIds,
    required super.transactionId,
    required super.merchantName,
    required super.onPay,
    super.getTransactionFunction,
    super.countDownInSeconds = 90,
    super.maxTransactionAmount = 5000,
    super.onCountComplete,
    super.locale,
    super.isMocked,
    super.onError,
    super.onTokenExpired,
    super.log,
    super.transactionType,
    super.flavor,
    super.environment,
    super.customerCallback,
  }) : super(
          amount: '',
          currency: '',
          onResponse: null,
          customerId: null,
          sessionToken: '',
        );

  factory AmwalInAppSdkSettings.fromJson(Map<String, dynamic> json) {
    return AmwalInAppSdkSettings(
      token: json['token'],
      maxTransactionAmount: json['maxTransactionAmount'],
      secureHashValue: json['secureHashValue'],
      merchantId: json['merchantId'],
      terminalIds: json['terminalIds'] ?? [],
      transactionId: json['transactionId'],
      merchantName: json['merchantName'],
      onPay: json['onPay'],
      countDownInSeconds: json['countDownInSeconds'],
      getTransactionFunction: json['getTransactionFunction'],
      onError: json['onError'],
      log: json['log'],
      onCountComplete: json['onCountComplete'],
      locale: json['locale'],
      isMocked: json['isMocked'],
      transactionType: json['isNfc'] == true
          ? TransactionType.nfc
          : TransactionType.cardWallet,
      onTokenExpired: json['onTokenExpired'],
      flavor: json['flavor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'sessionToken': sessionToken,
      'secureHashValue': secureHashValue,
      'merchantId': merchantId,
      'transactionId': transactionId,
      'currency': currency,
      'amount': amount,
      'merchantName': merchantName,
      'locale': locale,
      'maxTransactionAmount': maxTransactionAmount,
      'isMocked': isMocked,
      'countDownInSeconds': countDownInSeconds,
      'flavor': flavor,
      'isNfc': transactionType == TransactionType.nfc,
      'log': log,
    };
  }
}

class AmwalSdkSettings extends IAmwalSdkSettings {
  final String terminalId;

  AmwalSdkSettings({
    super.onResponse,
    super.token = '',
    super.secureHashValue,
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
    super.log,
    super.onTokenExpired,
    super.countDownInSeconds = 90,
    super.flavor,
    super.sessionToken = '',
    super.customerCallback,
    super.customerId,
    super.transactionType,
    super.environment,
    super.maxTransactionAmount,
  }) : super(terminalIds: [terminalId], onPay: (_, [__]) {});

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
      onCountComplete: null,
      locale: json['locale'],
      isMocked: json['isMocked'],
      transactionType: json['isNfc'] == true
          ? TransactionType.nfc
          : TransactionType.cardWallet,
      onError: null,
      log: null,
      onTokenExpired: null,
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
      'isNfc': transactionType == TransactionType.nfc,
      'terminalId': terminalId,
      'merchantName': merchantName,
      'locale': locale,
      'isMocked': isMocked,
      'countDownInSeconds': countDownInSeconds,
      'flavor': flavor,
    };
  }
}
