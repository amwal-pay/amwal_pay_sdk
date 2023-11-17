class TransactionOperationRequest {
   final String transactionId;
  final String originalTransactionIdentifierValue;
  final int originalTransactionIdentifierType;
  final int terminalId;
  final int merchantId;
  final int? currencyCode;
  final String requestDateTime;
  final String? processingCode;
  final String? messageTypeId;
  final String? UniqueNotificationId;
  final num? amount;
  final String? password;

//<editor-fold desc="Data Methods">
  const TransactionOperationRequest({
    this.amount,
     required this.transactionId,
    required this.originalTransactionIdentifierValue,
    required this.originalTransactionIdentifierType,
    required this.terminalId,
    required this.merchantId,
    this.currencyCode,
    required this.requestDateTime,
    this.processingCode,
    this.messageTypeId,
    this.UniqueNotificationId,
    this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionOperationRequest &&
          runtimeType == other.runtimeType &&

          transactionId == other.transactionId &&
          originalTransactionIdentifierValue ==
              other.originalTransactionIdentifierValue &&
          originalTransactionIdentifierType ==
              other.originalTransactionIdentifierType &&
          terminalId == other.terminalId &&
          merchantId == other.merchantId &&
          currencyCode == other.currencyCode &&
          requestDateTime == other.requestDateTime);

  @override
  int get hashCode =>

      transactionId.hashCode ^
      originalTransactionIdentifierValue.hashCode ^
      originalTransactionIdentifierType.hashCode ^
      terminalId.hashCode ^
      merchantId.hashCode ^
      currencyCode.hashCode ^
      requestDateTime.hashCode;

  TransactionOperationRequest copyWith({
     String? transactionId,
    String? originalTransactionIdentifierValue,
    int? originalTransactionIdentifierType,
    int? terminalId,
    int? merchantId,
    int? currencyCode,
    String? requestDateTime,
    num? amount,
  }) {
    return TransactionOperationRequest(

      transactionId: transactionId ?? this.transactionId,
      originalTransactionIdentifierValue: originalTransactionIdentifierValue ??
          this.originalTransactionIdentifierValue,
      originalTransactionIdentifierType: originalTransactionIdentifierType ??
          this.originalTransactionIdentifierType,
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      currencyCode: currencyCode ?? this.currencyCode,
      requestDateTime: requestDateTime ?? this.requestDateTime,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toWalletRefundMap() => {
        'processingCode': processingCode,
        'messageTypeId': messageTypeId,
        'transactionId': transactionId,
        'requestDateTime': requestDateTime,
        'terminalId': terminalId,
        'merchantId': merchantId,
        'transactionIdentifierValue': originalTransactionIdentifierValue,
        'transactionIdentifierType': originalTransactionIdentifierType,
        'UniqueNotificationId': transactionId,
        'requestSource': 6,
        'password': password,
      };

  Map<String, dynamic> toVoidRefundCardMap() => {
         'transactionId': transactionId,
        'transactionIdentifierValue': originalTransactionIdentifierValue,
        'transactionIdentifierType': originalTransactionIdentifierType,
        'requestDateTime': requestDateTime,
        'terminalId': terminalId,
        'merchantId': merchantId,
        'currencyCode': currencyCode,
        'amount': amount,
        'password': password,
      };

  Map<String, dynamic> toMap() {
    return {

      'transactionId': transactionId,
      'transactionIdentifierValue': originalTransactionIdentifierValue,
      'transactionIdentifierType': originalTransactionIdentifierType,
      'terminalId': terminalId,
      'merchantId': merchantId,
      'currencyCode': currencyCode,
      'requestDateTime': requestDateTime,
      'amount': amount,
      'password': password,
    };
  }

  factory TransactionOperationRequest.fromMap(Map<String, dynamic> map) {
    return TransactionOperationRequest(

      transactionId: map['transactionId'] as String,
      originalTransactionIdentifierValue:
          map['originalTransactionIdentifierValue'] as String,
      originalTransactionIdentifierType:
          map['originalTransactionIdentifierType'] as int,
      terminalId: map['terminalId'] as int,
      merchantId: map['merchantId'] as int,
      currencyCode: map['currencyCode'] as int,
      requestDateTime: map['requestDateTime'] as String,
    );
  }

//</editor-fold>
}
