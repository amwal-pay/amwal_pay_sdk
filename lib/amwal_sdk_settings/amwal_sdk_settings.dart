import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:flutter/material.dart';

abstract class IAmwalSdkSettings {
  final String requestSourceId;
  final String secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String? transactionRefNo;
  final Locale locale;
  final bool is3DS;
  final bool isMocked;
  final String amount;
  final String currency;
  final int currencyId;
  final String merchantName;
  final BuildContext? context;

  const IAmwalSdkSettings({
    required this.secureHashValue,
    required this.requestSourceId,
    required this.merchantId,
    required this.terminalIds,
    this.transactionRefNo,
    required this.currency,
    required this.amount,
    required this.context,
    required this.merchantName,
    required this.currencyId,
    this.locale = const Locale('en'),
    this.is3DS = false,
    this.isMocked = false,
  });
}

class AmwalInAppSdkSettings extends IAmwalSdkSettings {
  const AmwalInAppSdkSettings({
    required super.secureHashValue,
    required super.merchantId,
    required super.terminalIds,
    required super.transactionRefNo,
    required super.currency,
    required super.amount,
    required super.context,
    required super.merchantName,
    required super.currencyId,
    super.locale,
    super.is3DS,
    super.isMocked,
  }) : super(requestSourceId: '6');
}

class AmwalSdkSettings extends IAmwalSdkSettings {
  final String terminalId;
  AmwalSdkSettings({
    required super.secureHashValue,
    required super.merchantId,
    super.transactionRefNo,
    required super.currency,
    required super.amount,
    required this.terminalId,
    required super.merchantName,
    required super.currencyId,
    super.context,
    super.locale,
    super.isMocked,
    super.is3DS,
  }) : super(
          requestSourceId: '7',
          terminalIds: [terminalId],
        );

  AmwalSdkSettings copyWith({
    BuildContext? context,
  }) {
    return AmwalSdkSettings(
      terminalId: terminalId,
      context: context ?? this.context,
      locale: locale,
      is3DS: is3DS,
      isMocked: isMocked,
      currency: currency,
      amount: amount,
      merchantId: merchantId,
      secureHashValue: secureHashValue,
      transactionRefNo: transactionRefNo,
      merchantName: merchantName,
      currencyId: currencyId,
    );
  }

  factory AmwalSdkSettings.fromArgs(List<String> args) {
    return AmwalSdkSettings(
        merchantId: args[0],
        currency: args[1],
        currencyId: int.parse(args[2]),
        amount: args[3],
        terminalId: args[4],
        isMocked: args[5] == '1',
        merchantName: args[6],
        secureHashValue: args[7]);
  }
}
