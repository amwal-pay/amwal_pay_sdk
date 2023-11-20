import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';

class PaymentArguments {
  final String amount;
  final String terminalId;
  final CurrencyData? currencyData;
  final int merchantId;
  String? transactionId;

  PaymentArguments({
    required this.amount,
    required this.terminalId,
    required this.merchantId,
    this.transactionId,
    this.currencyData,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'terminalId': terminalId,
      'transactionId': transactionId,
      'currencyData': currencyData?.toJson(),
    };
  }

  factory PaymentArguments.fromMap(Map<String, dynamic> map) {
    return PaymentArguments(
      amount: map['amount'] as String,
      terminalId: map['terminalId'] as String,
      merchantId: map['merchantId'] as int,
      currencyData: CurrencyData.fromJson(map['currencyData']),
      transactionId: map['transactionId'],
    );
  }
}
