import 'package:flutter/material.dart';

abstract class IAmwalSdkSettings {
  final String token;
  final String requestSourceId;
  final String secureHashValue;
  final String merchantId;
  final List<String> terminalIds;
  final String transactionRefNo;
  final Locale locale;
  final bool is3DS;
  final bool isMocked;
  final String amount;
  final String currency;
  final BuildContext? context;

  const IAmwalSdkSettings({
    required this.token,
    required this.secureHashValue,
    required this.requestSourceId,
    required this.merchantId,
    required this.terminalIds,
    required this.transactionRefNo,
    required this.currency,
    required this.amount,
    required this.context,
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
    required super.transactionRefNo,
    required super.currency,
    required super.amount,
    required super.context,
    super.locale,
    super.is3DS,
    super.isMocked,
  }) : super(requestSourceId: '6');
}

class AmwalSdkSettings extends IAmwalSdkSettings {
  final String terminalId;
  AmwalSdkSettings({
    required super.token,
    required super.secureHashValue,
    required super.merchantId,
    required super.transactionRefNo,
    required super.currency,
    required super.amount,
    required this.terminalId,
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
      token: token,
      locale: locale,
      is3DS: is3DS,
      isMocked: isMocked,
      currency: currency,
      amount: amount,
      merchantId: merchantId,
      secureHashValue: secureHashValue,
      transactionRefNo: transactionRefNo,
    );
  }

  factory AmwalSdkSettings.fromArgs(List<String> args) {
    return AmwalSdkSettings(
      token: args[0],
      secureHashValue: args[1],
      merchantId: args[2],
      currency: args[3],
      amount: args[4],
      terminalId: args[5],
      isMocked: args[6] == '1',
      is3DS: args[7] == '1',
      transactionRefNo: args[8],

    );
  }
}
