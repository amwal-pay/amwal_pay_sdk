class PurchaseRequest {
  final String pan;

  final num amount;
  final int terminalId;
  final int merchantId;
  final String cardHolderName;
  final String cvV2;
  final String? merchantReference;
  final String dateExpiration;
  final String? refundReason;
  // final String requestDateTime;
  final String orderCustomerEmail;
  final String? otp;
  final String? orderKey;
  final String clientMail;
  final int? transactionIdentifierType;
  final String? transactionIdentifierValue;
  final String? currencyCode;
  final int? currencyId;
  final String? transactionId;
  final bool isTokenized;
  final String? customerId;
  final String? customerTokenId;

//<editor-fold desc="Data Methods">
  const PurchaseRequest({
    required this.pan,
    required this.amount,
    required this.terminalId,
    required this.merchantId,
    required this.cardHolderName,
    required this.cvV2,
    this.merchantReference,
    required this.dateExpiration,
    this.refundReason,
    required this.orderCustomerEmail,
    this.otp,
    this.orderKey,
    required this.clientMail,
    this.transactionIdentifierType,
    this.transactionIdentifierValue,
    this.currencyCode,
    this.currencyId,
    this.transactionId,
    this.isTokenized = false,
    this.customerId,
    this.customerTokenId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseRequest &&
          runtimeType == other.runtimeType &&
          pan == other.pan &&
          amount == other.amount &&
          terminalId == other.terminalId &&
          merchantId == other.merchantId &&
          cardHolderName == other.cardHolderName &&
          cvV2 == other.cvV2 &&
          merchantReference == other.merchantReference &&
          dateExpiration == other.dateExpiration &&
          refundReason == other.refundReason &&
          // requestDateTime == other.requestDateTime &&
          orderCustomerEmail == other.orderCustomerEmail &&
          otp == other.otp &&
          orderKey == other.orderKey &&
          clientMail == other.clientMail &&
          transactionIdentifierType == other.transactionIdentifierType &&
          currencyCode == other.currencyCode &&
          currencyId == other.currencyId &&
          transactionId == other.transactionId);

  @override
  int get hashCode =>
      pan.hashCode ^
      amount.hashCode ^
      terminalId.hashCode ^
      merchantId.hashCode ^
      cardHolderName.hashCode ^
      cvV2.hashCode ^
      merchantReference.hashCode ^
      dateExpiration.hashCode ^
      refundReason.hashCode ^
      // requestDateTime.hashCode ^
      orderCustomerEmail.hashCode ^
      otp.hashCode ^
      orderKey.hashCode ^
      clientMail.hashCode ^
      transactionIdentifierType.hashCode ^
      currencyCode.hashCode ^
      currencyId.hashCode ^
      transactionId.hashCode;

  PurchaseRequest copyWith({
    String? pan,
    num? amount,
    String? track2Data,
    int? terminalId,
    int? merchantId,
    String? isCardSystemRelatedData,
    String? cardHolderName,
    String? cvV2,
    String? batchId,
    String? merchantReference,
    String? dateExpiration,
    String? refundReason,
    String? requestDateTime,
    String? orderCustomerEmail,
    String? otp,
    String? orderKey,
    String? clientMail,
    int? transactionIdentifierType,
    String? currencyCode,
    int? currencyId,
    String? transactionId,
  }) {
    return PurchaseRequest(
      pan: pan ?? this.pan,
      amount: amount ?? this.amount,
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cvV2: cvV2 ?? this.cvV2,
      merchantReference: merchantReference ?? this.merchantReference,
      dateExpiration: dateExpiration ?? this.dateExpiration,
      refundReason: refundReason ?? this.refundReason,
      orderCustomerEmail: orderCustomerEmail ?? this.orderCustomerEmail,
      otp: otp ?? this.otp,
      orderKey: orderKey ?? this.orderKey,
      clientMail: clientMail ?? this.clientMail,
      transactionIdentifierType:
          transactionIdentifierType ?? this.transactionIdentifierType,
      currencyCode: currencyCode ?? this.currencyCode,
      currencyId: currencyId ?? this.currencyId,
      transactionId: transactionId ?? this.transactionId,
      isTokenized: isTokenized,
      customerId: customerId,
      customerTokenId: customerTokenId,
    );
  }

  Map<String, dynamic> mapToPayWithToken() => {
        'amount': amount,
        'terminalId': terminalId,
        'merchantId': merchantId,
        'currencyCode': currencyCode,
        'transactionId': transactionId,
        'clientMail': clientMail,
        'customerId': customerId,
        'customerTokenId': customerTokenId,
        'cvV2': cvV2,
      };

  Map<String, dynamic> mapToPurchaseData() => {
        'pan': pan,
        'amount': amount,
        'terminalId': terminalId,
        'merchantId': merchantId,
        'cardHolderName': cardHolderName,
        'cvV2': cvV2,
        'dateExpiration': dateExpiration,
        'orderCustomerEmail': orderCustomerEmail,
        'clientMail': clientMail,
        'currencyCode': currencyCode,
        'transactionId': transactionId,
        'isTokenized': isTokenized,
      };

  Map<String, dynamic> mapToPurchaseStepOneData() {
    Map<String, dynamic> data = {
      'pan': pan,
      'amount': amount,
      'terminalId': terminalId,
      'cardHolderName': cardHolderName,
      'cvV2': cvV2,
      'dateExpiration': dateExpiration,
      'currencyCode': currencyCode,
      'transactionId': transactionId,
      'isTokenized': isTokenized,
    };
    if (merchantId != 0) {
      data['merchantId'] = merchantId;
    }

    if (orderCustomerEmail.isNotEmpty) {
      data['orderCustomerEmail'] = orderCustomerEmail;
    }

    if (clientMail.isNotEmpty) {
      data['clientMail'] = clientMail;
    }

    if (cvV2.isEmpty) {
      data['transactionMethod'] = "9";
    }
    return data;
  }

  Map<String, dynamic> mapToPurchaseStepTwoData() {
    Map<String, dynamic> data = {
      'pan': pan,
      'otp': otp,
      'amount': amount,
      'terminalId': terminalId,
      'merchantId': merchantId,
      'cardHolderName': cardHolderName,
      'cvV2': cvV2,
      'dateExpiration': dateExpiration,
      'currencyCode': currencyCode,
      'transactionId': transactionId,
      'transactionIdentifierType': transactionIdentifierType,
      'transactionIdentifierValue': transactionIdentifierValue,
      'isTokenized': isTokenized,
    };

    if (orderCustomerEmail.isNotEmpty) {
      data['orderCustomerEmail'] = orderCustomerEmail;
    }

    if (clientMail.isNotEmpty) {
      data['clientMail'] = clientMail;
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'pan': pan,
      'amount': amount,
      'terminalId': terminalId,
      'merchantId': merchantId,
      'cardHolderName': cardHolderName,
      'cvV2': cvV2,
      'merchantReference': merchantReference,
      'dateExpiration': dateExpiration,
      'refundReason': refundReason,
      // 'requestDateTime': requestDateTime,
      'orderCustomerEmail': orderCustomerEmail,
      'otp': otp,
      'orderKey': orderKey,
      'clientMail': clientMail,
      'transactionIdentifierType': 0,
      'currencyCode': 512,
      'currencyId': 512,
      'transactionId': transactionId,
    };
  }

  factory PurchaseRequest.fromMap(Map<String, dynamic> map) {
    return PurchaseRequest(
      pan: map['pan'] as String,
      amount: map['amount'] as num,
      terminalId: map['terminalId'] as int,
      merchantId: map['merchantId'] as int,
      cardHolderName: map['cardHolderName'] as String,
      cvV2: map['cvV2'] as String,
      merchantReference: map['merchantReference'] as String,
      dateExpiration: map['dateExpiration'] as String,
      refundReason: map['refundReason'] as String,
      // requestDateTime: map['requestDateTime'] as String,
      orderCustomerEmail: map['orderCustomerEmail'] as String,
      otp: map['otp'] as String,
      orderKey: map['orderKey'] as String,
      clientMail: map['clientMail'] as String,
      transactionIdentifierType: map['transactionIdentifierType'] as int,
      currencyCode: map['currencyCode'] as String,
      currencyId: map['currencyId'] as int,
      transactionId: map['transactionId'] as String,
    );
  }

//</editor-fold>
}
