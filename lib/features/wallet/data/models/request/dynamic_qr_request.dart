class DynamicQRRequest{
  final int terminalId;
  final int merchantId;
  final num amount;
  final int currencyId;

//<editor-fold desc="Data Methods">
  const DynamicQRRequest({
    required this.terminalId,
    required this.merchantId,
    required this.amount,
    required this.currencyId,
  });



  DynamicQRRequest copyWith({
    int? terminalId,
    int? merchantId,
    String? requestDateTime,
    int? dataProvider,
    num? amount,
    int? currency,
  }) {
    return DynamicQRRequest(
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      amount: amount ?? this.amount,
      currencyId: currency ?? this.currencyId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'terminalId': terminalId,
      'merchantId': merchantId,
      'requestDateTime': DateTime.now().toIso8601String(),
      'dataProvider': 2,
      'amount': amount,
      'currency': currencyId,
    };
  }

  factory DynamicQRRequest.fromMap(Map<String, dynamic> map) {
    return DynamicQRRequest(
      terminalId: map['terminalId'] as int,
      merchantId: map['merchantId'] as int,

      amount: map['amount'] as num,
      currencyId: map['currency'] as int,
    );
  }

//</editor-fold>
}