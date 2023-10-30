import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';

class PaymentArguments {
  final String amount;
  final String terminalId;
  final CurrencyData? currencyData;
  final bool is3DS;
  final String merchantName;

  const PaymentArguments({
    required this.amount,
    required this.terminalId,
    required this.merchantName,
    this.currencyData,
    this.is3DS = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'terminalId': terminalId,
      'currencyData': currencyData?.toJson(),
      'merchantName': merchantName,
    };
  }

  factory PaymentArguments.fromMap(Map<String, dynamic> map) {
    return PaymentArguments(
      amount: map['amount'] as String,
      terminalId: map['terminalId'] as String,
      currencyData: CurrencyData.fromJson(map['currencyData']),
      merchantName: map['merchantName'],
    );
  }
}
