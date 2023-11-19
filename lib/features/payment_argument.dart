import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';

class PaymentArguments {
  final String amount;
  final String terminalId;
  final CurrencyData? currencyData;
  final String merchantName;
  final int merchantId;
  final String? transactionId;

  const PaymentArguments({
    required this.amount,
    required this.terminalId,
    required this.merchantName,
    required this.merchantId,
    this.currencyData,
    this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'terminalId': terminalId,
      'currencyData': currencyData?.toJson(),
      'merchantName': merchantName,
      "merchantId": merchantId,
    };
  }

  factory PaymentArguments.fromMap(Map<String, dynamic> map) {
    return PaymentArguments(
      amount: map['amount'] as String,
      terminalId: map['terminalId'] as String,
      currencyData: CurrencyData.fromJson(map['currencyData']),
      merchantName: map['merchantName'],
      merchantId: map['merchantId'],
    );
  }

  PaymentArguments copyWith({
    String? amount,
    String? terminalId,
    CurrencyData? currencyData,
    String? merchantName,
    int? merchantId,
    String? transactionId,
  }) {
    return PaymentArguments(
      amount: amount ?? this.amount,
      terminalId: terminalId ?? this.terminalId,
      currencyData: currencyData ?? this.currencyData,
      merchantName: merchantName ?? this.merchantName,
      merchantId: merchantId ?? this.merchantId,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
