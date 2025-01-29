import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class OneTransactionResponse extends BaseResponse<OneTransaction> {
  OneTransactionResponse({
    required super.success,
    super.data,
    super.message,
  });

  factory OneTransactionResponse.fromJson(dynamic json) {
    return OneTransactionResponse(
      success: json['success'],
      message: json['message'],
      data: OneTransaction.fromMap(json['data']),
    );
  }
}

class OneTransaction {
  final int idN;
  final String? id;
  final String? gatewayTransactionReference;
  final String? transactionTime;
  final num amount;
  final num totalAmount;
  final num tips;
  final int convFees;
  final String? cardNumber;
  final String? cvV2;
  final String? cardHolderName;
  final String? cardHolderEmail;
  final String? cardHolderMobile;
  final String? responseCodeName;
  final bool isRefunded;
  final bool isCaptured;
  final int terminalNodeId;
  final int transactionMethodId;
  final int hostId;
  final int currencyId;
  final String? currency;
  final int transactionTypeId;
  final String? transactionType;
  final int? originalTransactionId;
  final String? stan;
  final int terminalTypeId;
  final int requestSourceId;
  final int? terminalType;
  final int channelType;
  final String? methodName;
  final int bankId;
  final int? aggregatorId;
  final String? aggregator;
  final String? transactionTypeDisplayName;
  final int? amsTransactionStatusId;
  final String? orderId;
  final DigitalTransaction? digitalTransaction;
  final String? merchantName;
  final int merchantId;
  final int terminalId;
  final TransactionActions? transactionActions;
  final num? amountAvailableForRefundOrCompletion;

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['idN'] = idN;
    data['id'] = id;
    data['transactionTime'] = transactionTime;
    data['amount'] = amount;
    data['totalAmount'] = totalAmount;
    data['tips'] = tips;
    data['convFees'] = convFees;
    data['cardNumber'] = cardNumber;
    data['cvV2'] = cvV2;
    data['cardHolderName'] = cardHolderName;
    data['cardHolderEmail'] = cardHolderEmail;
    data['gatewayTransactionReference'] = gatewayTransactionReference;
    data['cardHolderMobile'] = cardHolderMobile;
    data['responseCodeName'] = responseCodeName;
    data['isRefunded'] = isRefunded;
    data['isCaptured'] = isCaptured;
    data['terminalNodeId'] = terminalNodeId;
    data['transactionMethodId'] = transactionMethodId;
    data['hostId'] = hostId;
    data['currencyId'] = currencyId;
    data['currency'] = currency;
    data['transactionTypeId'] = transactionTypeId;
    data['transactionType'] = transactionType;
    data['originalTransactionId'] = originalTransactionId;
    data['stan'] = stan;
    data['terminalTypeId'] = terminalTypeId;
    data['requestSourceId'] = requestSourceId;
    data['terminalType'] = terminalType;
    data['channelType'] = channelType;
    data['methodName'] = methodName;
    data['bankId'] = bankId;
    data['aggregatorId'] = aggregatorId;
    data['aggregator'] = aggregator;
    data['transactionTypeDisplayName'] = transactionTypeDisplayName;
    data['amsTransactionStatusId'] = amsTransactionStatusId;
    data['orderId'] = orderId;
    if (digitalTransaction != null) {
      data['digitalTransaction'] = digitalTransaction?.toJson();
    }
    data['transactionActions'] = transactionActions?.toMap();
    return data;
  }

//<editor-fold desc="Data Methods">
  const OneTransaction({
    required this.idN,
    required this.id,
    required this.merchantId,
    required this.terminalId,
    required this.merchantName,
    required this.transactionTime,
    required this.amount,
    required this.totalAmount,
    required this.tips,
    required this.convFees,
    this.transactionActions,
    this.cardNumber,
    this.gatewayTransactionReference,
     this.cvV2,
    this.cardHolderName,
    this.cardHolderEmail,
    this.cardHolderMobile,
    required this.responseCodeName,
    required this.isRefunded,
    required this.isCaptured,
    required this.terminalNodeId,
    required this.transactionMethodId,
    required this.hostId,
    required this.currencyId,
    required this.currency,
    required this.transactionTypeId,
    required this.transactionType,
    this.originalTransactionId,
    this.stan,
    required this.terminalTypeId,
    required this.requestSourceId,
    this.terminalType,
    required this.channelType,
    required this.methodName,
    required this.bankId,
    this.aggregatorId,
    this.aggregator,
    required this.transactionTypeDisplayName,
    this.amsTransactionStatusId,
    required this.orderId,
    required this.digitalTransaction,
    this.amountAvailableForRefundOrCompletion,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OneTransaction &&
          runtimeType == other.runtimeType &&
          idN == other.idN &&
          id == other.id &&
          transactionTime == other.transactionTime &&
          amount == other.amount &&
          totalAmount == other.totalAmount &&
          tips == other.tips &&
          convFees == other.convFees &&
          cardNumber == other.cardNumber &&
          cvV2 == other.cvV2 &&
          cardHolderName == other.cardHolderName &&
          cardHolderEmail == other.cardHolderEmail &&
          cardHolderMobile == other.cardHolderMobile &&
          responseCodeName == other.responseCodeName &&
          isRefunded == other.isRefunded &&
          isCaptured == other.isCaptured &&
          terminalNodeId == other.terminalNodeId &&
          transactionMethodId == other.transactionMethodId &&
          hostId == other.hostId &&
          currencyId == other.currencyId &&
          currency == other.currency &&
          transactionTypeId == other.transactionTypeId &&
          transactionType == other.transactionType &&
          originalTransactionId == other.originalTransactionId &&
          stan == other.stan &&
          terminalTypeId == other.terminalTypeId &&
          requestSourceId == other.requestSourceId &&
          terminalType == other.terminalType &&
          channelType == other.channelType &&
          methodName == other.methodName &&
          bankId == other.bankId &&
          aggregatorId == other.aggregatorId &&
          aggregator == other.aggregator &&
          transactionTypeDisplayName == other.transactionTypeDisplayName &&
          amsTransactionStatusId == other.amsTransactionStatusId &&
          orderId == other.orderId &&
          digitalTransaction == other.digitalTransaction);

  @override
  int get hashCode =>
      idN.hashCode ^
      id.hashCode ^
      transactionTime.hashCode ^
      amount.hashCode ^
      totalAmount.hashCode ^
      tips.hashCode ^
      convFees.hashCode ^
      cardNumber.hashCode ^
      cvV2.hashCode ^
      cardHolderName.hashCode ^
      cardHolderEmail.hashCode ^
      cardHolderMobile.hashCode ^
      responseCodeName.hashCode ^
      isRefunded.hashCode ^
      isCaptured.hashCode ^
      terminalNodeId.hashCode ^
      transactionMethodId.hashCode ^
      hostId.hashCode ^
      currencyId.hashCode ^
      currency.hashCode ^
      transactionTypeId.hashCode ^
      transactionType.hashCode ^
      originalTransactionId.hashCode ^
      stan.hashCode ^
      terminalTypeId.hashCode ^
      requestSourceId.hashCode ^
      terminalType.hashCode ^
      channelType.hashCode ^
      methodName.hashCode ^
      bankId.hashCode ^
      aggregatorId.hashCode ^
      aggregator.hashCode ^
      transactionTypeDisplayName.hashCode ^
      amsTransactionStatusId.hashCode ^
      orderId.hashCode ^
      digitalTransaction.hashCode;

  OneTransaction copyWith({
    int? idN,
    String? id,
    String? transactionTime,
    int? amount,
    int? totalAmount,
    int? tips,
    int? convFees,
    String? cardNumber,
    String? cvV2,
    String? cardHolderName,
    String? cardHolderEmail,
    String? cardHolderMobile,
    String? responseCodeName,
    bool? isRefunded,
    bool? isCaptured,
    int? terminalNodeId,
    int? transactionMethodId,
    int? hostId,
    int? currencyId,
    String? currency,
    int? transactionTypeId,
    String? transactionType,
    int? originalTransactionId,
    String? stan,
    int? terminalTypeId,
    int? requestSourceId,
    int? terminalType,
    int? channelType,
    String? methodName,
    int? bankId,
    int? aggregatorId,
    String? aggregator,
    String? transactionTypeDisplayName,
    int? amsTransactionStatusId,
    String? orderId,
    DigitalTransaction? digitalTransaction,
    String? merchantName,
    int? merchantId,
    int? terminalId,
    TransactionActions? transactionActions,
  }) {
    return OneTransaction(
      transactionActions: transactionActions ?? this.transactionActions,
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      idN: idN ?? this.idN,
      id: id ?? this.id,
      transactionTime: transactionTime ?? this.transactionTime,
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      tips: tips ?? this.tips,
      convFees: convFees ?? this.convFees,
      cardNumber: cardNumber ?? this.cardNumber,
      cvV2: cvV2 ?? this.cvV2,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      cardHolderEmail: cardHolderEmail ?? this.cardHolderEmail,
      cardHolderMobile: cardHolderMobile ?? this.cardHolderMobile,
      responseCodeName: responseCodeName ?? this.responseCodeName,
      isRefunded: isRefunded ?? this.isRefunded,
      isCaptured: isCaptured ?? this.isCaptured,
      terminalNodeId: terminalNodeId ?? this.terminalNodeId,
      transactionMethodId: transactionMethodId ?? this.transactionMethodId,
      hostId: hostId ?? this.hostId,
      currencyId: currencyId ?? this.currencyId,
      currency: currency ?? this.currency,
      transactionTypeId: transactionTypeId ?? this.transactionTypeId,
      transactionType: transactionType ?? this.transactionType,
      originalTransactionId:
          originalTransactionId ?? this.originalTransactionId,
      stan: stan ?? this.stan,
      terminalTypeId: terminalTypeId ?? this.terminalTypeId,
      requestSourceId: requestSourceId ?? this.requestSourceId,
      terminalType: terminalType ?? this.terminalType,
      channelType: channelType ?? this.channelType,
      methodName: methodName ?? this.methodName,
      bankId: bankId ?? this.bankId,
      aggregatorId: aggregatorId ?? this.aggregatorId,
      aggregator: aggregator ?? this.aggregator,
      transactionTypeDisplayName:
          transactionTypeDisplayName ?? this.transactionTypeDisplayName,
      amsTransactionStatusId:
          amsTransactionStatusId ?? this.amsTransactionStatusId,
      orderId: orderId ?? this.orderId,
      digitalTransaction: digitalTransaction ?? this.digitalTransaction,
    );
  }

  Map<String?, dynamic> toMap() {
    return {
      'idN': idN,
      'id': id,
      'transactionTime': transactionTime,
      'amount': amount,
      'totalAmount': totalAmount,
      'tips': tips,
      'convFees': convFees,
      'cardNumber': cardNumber,
      'cvV2': cvV2,
      'cardHolderName': cardHolderName,
      'gatewayTransactionReference': gatewayTransactionReference,
      'cardHolderEmail': cardHolderEmail,
      'cardHolderMobile': cardHolderMobile,
      'responseCodeName': responseCodeName,
      'isRefunded': isRefunded,
      'isCaptured': isCaptured,
      'terminalNodeId': terminalNodeId,
      'transactionMethodId': transactionMethodId,
      'hostId': hostId,
      'currencyId': currencyId,
      'currency': currency,
      'transactionTypeId': transactionTypeId,
      'transactionType': transactionType,
      'originalTransactionId': originalTransactionId,
      'stan': stan,
      'terminalTypeId': terminalTypeId,
      'requestSourceId': requestSourceId,
      'terminalType': terminalType,
      'channelType': channelType,
      'methodName': methodName,
      'bankId': bankId,
      'aggregatorId': aggregatorId,
      'aggregator': aggregator,
      'transactionTypeDisplayName': transactionTypeDisplayName,
      'amsTransactionStatusId': amsTransactionStatusId,
      'orderId': orderId,
      'digitalTransaction': digitalTransaction,
    };
  }

  factory OneTransaction.fromMap(Map<String?, dynamic> map) {
    return OneTransaction(
      transactionActions: map['transactionActions'] != null
          ? TransactionActions.fromMap(map['transactionActions'])
          : null,
      merchantName: map['merchantName'] as String?,
      merchantId: map['merchantId'] as int,
      terminalId: map['terminalId'] as int,
      idN: map['idN'] as int,
      id: map['id'] as String?,
      transactionTime: map['transactionTime'] as String?,
      gatewayTransactionReference: map['gatewayTransactionReference'] as String?,
      amount: map['amount'] as num,
      totalAmount: map['totalAmount'] as int,
      tips: map['tips'] as int,
      convFees: map['convFees'] as int,
      cardNumber: map['cardNumber'] as String?,
      cvV2: map['cvV2'] as String?,
      cardHolderName: map['cardHolderName'] as String?,
      cardHolderEmail: map['cardHolderEmail'] as String?,
      cardHolderMobile: map['cardHolderMobile'] as String?,
      responseCodeName: map['responseCodeName'] as String?,
      isRefunded: map['isRefunded'] as bool,
      isCaptured: map['isCaptured'] as bool,
      terminalNodeId: map['terminalNodeId'] as int,
      transactionMethodId: map['transactionMethodId'] as int,
      hostId: map['hostId'] as int,
      currencyId: map['currencyId'] as int,
      currency: map['currency'] as String?,
      transactionTypeId: map['transactionTypeId'] as int,
      transactionType: map['transactionType'] as String?,
      originalTransactionId: map['originalTransactionId'] as int?,
      stan: map['stan'] as String?,
      terminalTypeId: map['terminalTypeId'] as int,
      requestSourceId: map['requestSourceId'] as int,
      terminalType: map['terminalType'] as int?,
      channelType: map['channelType'] as int,
      methodName: map['methodName'] as String?,
      bankId: map['bankId'] as int,
      aggregatorId: map['aggregatorId'] as int?,
      aggregator: map['aggregator'] as String?,
      transactionTypeDisplayName: map['transactionTypeDisplayName'] as String?,
      amsTransactionStatusId: map['amsTransactionStatusId'] as int?,
      orderId: map['orderId'] as String?,
      amountAvailableForRefundOrCompletion:
          map['amountAvailableForRefundOrCompletion'],
      digitalTransaction: map['digitalTransaction'] != null
          ? DigitalTransaction.fromMap(map['digitalTransaction'])
          : null,
    );
  }

//</editor-fold>
}

class DigitalTransaction {
  final int idN;
  final String? createdDatetime;
  final String? maxResponseDatetime;
  final String? status;
  final int? aggregatorId;
  final String? externalTransactionId;
  final String? originalExternalTransactionId;
  final String? senderMobileNo;
  final String? receiverMobileNo;
  final int? originalTransactionId;
  final String? senderName;
  final String? senderAddress;
  final String? receiverName;
  final String? receiverAddress;
  final String? senderReferenceNo;
  final bool isRefunded;
  final String? refundReason;
  final String? refundSource;
  final String? refundCreatorId;
  final int? transactionId;
  final int requestSourceId;
  final String? orderId;

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['idN'] = idN;
    data['createdDatetime'] = createdDatetime;
    data['maxResponseDatetime'] = maxResponseDatetime;
    data['status'] = status;
    data['aggregatorId'] = aggregatorId;
    data['externalTransactionId'] = externalTransactionId;
    data['originalExternalTransactionId'] = originalExternalTransactionId;
    data['senderMobileNo'] = senderMobileNo;
    data['receiverMobileNo'] = receiverMobileNo;
    data['originalTransactionId'] = originalTransactionId;
    data['senderName'] = senderName;
    data['senderAddress'] = senderAddress;
    data['receiverName'] = receiverName;
    data['receiverAddress'] = receiverAddress;
    data['senderReferenceNo'] = senderReferenceNo;
    data['isRefunded'] = isRefunded;
    data['refundReason'] = refundReason;
    data['refundSource'] = refundSource;
    data['refundCreatorId'] = refundCreatorId;
    data['transactionId'] = transactionId;
    data['requestSourceId'] = requestSourceId;
    data['orderId'] = orderId;
    return data;
  }

//<editor-fold desc="Data Methods">
  DigitalTransaction({
    required this.idN,
    required this.createdDatetime,
     this.maxResponseDatetime,
      this.status,
    required this.aggregatorId,
      this.externalTransactionId,
    required this.originalExternalTransactionId,
    required this.senderMobileNo,
    required this.receiverMobileNo,
    required this.originalTransactionId,
    this.senderName,
    required this.senderAddress,
    required this.receiverName,
    required this.receiverAddress,
    required this.senderReferenceNo,
    required this.isRefunded,
    required this.refundReason,
    required this.refundSource,
    required this.refundCreatorId,
    required this.transactionId,
    required this.requestSourceId,
      this.orderId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DigitalTransaction &&
          runtimeType == other.runtimeType &&
          idN == other.idN &&
          createdDatetime == other.createdDatetime &&
          maxResponseDatetime == other.maxResponseDatetime &&
          status == other.status &&
          aggregatorId == other.aggregatorId &&
          externalTransactionId == other.externalTransactionId &&
          originalExternalTransactionId ==
              other.originalExternalTransactionId &&
          senderMobileNo == other.senderMobileNo &&
          receiverMobileNo == other.receiverMobileNo &&
          originalTransactionId == other.originalTransactionId &&
          senderName == other.senderName &&
          senderAddress == other.senderAddress &&
          receiverName == other.receiverName &&
          receiverAddress == other.receiverAddress &&
          senderReferenceNo == other.senderReferenceNo &&
          isRefunded == other.isRefunded &&
          refundReason == other.refundReason &&
          refundSource == other.refundSource &&
          refundCreatorId == other.refundCreatorId &&
          transactionId == other.transactionId &&
          requestSourceId == other.requestSourceId &&
          orderId == other.orderId);

  @override
  int get hashCode =>
      idN.hashCode ^
      createdDatetime.hashCode ^
      maxResponseDatetime.hashCode ^
      status.hashCode ^
      aggregatorId.hashCode ^
      externalTransactionId.hashCode ^
      originalExternalTransactionId.hashCode ^
      senderMobileNo.hashCode ^
      receiverMobileNo.hashCode ^
      originalTransactionId.hashCode ^
      senderName.hashCode ^
      senderAddress.hashCode ^
      receiverName.hashCode ^
      receiverAddress.hashCode ^
      senderReferenceNo.hashCode ^
      isRefunded.hashCode ^
      refundReason.hashCode ^
      refundSource.hashCode ^
      refundCreatorId.hashCode ^
      transactionId.hashCode ^
      requestSourceId.hashCode ^
      orderId.hashCode;

  DigitalTransaction copyWith({
    int? idN,
    String? createdDatetime,
    String? maxResponseDatetime,
    String? status,
    int? aggregatorId,
    String? externalTransactionId,
    String? originalExternalTransactionId,
    String? senderMobileNo,
    String? receiverMobileNo,
    int? originalTransactionId,
    String? senderName,
    String? senderAddress,
    String? receiverName,
    String? receiverAddress,
    String? senderReferenceNo,
    bool? isRefunded,
    String? refundReason,
    String? refundSource,
    String? refundCreatorId,
    int? transactionId,
    int? requestSourceId,
    String? orderId,
  }) {
    return DigitalTransaction(
      idN: idN ?? this.idN,
      createdDatetime: createdDatetime ?? this.createdDatetime,
      maxResponseDatetime: maxResponseDatetime ?? this.maxResponseDatetime,
      status: status ?? this.status,
      aggregatorId: aggregatorId ?? this.aggregatorId,
      externalTransactionId:
          externalTransactionId ?? this.externalTransactionId,
      originalExternalTransactionId:
          originalExternalTransactionId ?? this.originalExternalTransactionId,
      senderMobileNo: senderMobileNo ?? this.senderMobileNo,
      receiverMobileNo: receiverMobileNo ?? this.receiverMobileNo,
      originalTransactionId:
          originalTransactionId ?? this.originalTransactionId,
      senderName: senderName ?? this.senderName,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverName: receiverName ?? this.receiverName,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      senderReferenceNo: senderReferenceNo ?? this.senderReferenceNo,
      isRefunded: isRefunded ?? this.isRefunded,
      refundReason: refundReason ?? this.refundReason,
      refundSource: refundSource ?? this.refundSource,
      refundCreatorId: refundCreatorId ?? this.refundCreatorId,
      transactionId: transactionId ?? this.transactionId,
      requestSourceId: requestSourceId ?? this.requestSourceId,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String?, dynamic> toMap() {
    return {
      'idN': idN,
      'createdDatetime': createdDatetime,
      'maxResponseDatetime': maxResponseDatetime,
      'status': status,
      'aggregatorId': aggregatorId,
      'externalTransactionId': externalTransactionId,
      'originalExternalTransactionId': originalExternalTransactionId,
      'senderMobileNo': senderMobileNo,
      'receiverMobileNo': receiverMobileNo,
      'originalTransactionId': originalTransactionId,
      'senderName': senderName,
      'senderAddress': senderAddress,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'senderReferenceNo': senderReferenceNo,
      'isRefunded': isRefunded,
      'refundReason': refundReason,
      'refundSource': refundSource,
      'refundCreatorId': refundCreatorId,
      'transactionId': transactionId,
      'requestSourceId': requestSourceId,
      'orderId': orderId,
    };
  }

  factory DigitalTransaction.fromMap(Map<String?, dynamic> map) {
    return DigitalTransaction(
      idN: map['idN'] as int,
      createdDatetime: map['createdDatetime'] as String?,
      maxResponseDatetime: map['maxResponseDatetime'] as String?,
      status: map['status'] as String?,
      aggregatorId: map['aggregatorId'] as int?,
      externalTransactionId: map['externalTransactionId'] as String?,
      originalExternalTransactionId:
          map['originalExternalTransactionId'] as String?,
      senderMobileNo: map['senderMobileNo'] as String?,
      receiverMobileNo: map['receiverMobileNo'] as String?,
      originalTransactionId: map['originalTransactionId'] as int?,
      senderName: map['senderName'] as String?,
      senderAddress: map['senderAddress'] as String?,
      receiverName: map['receiverName'] as String?,
      receiverAddress: map['receiverAddress'] as String?,
      senderReferenceNo: map['senderReferenceNo'] as String?,
      isRefunded: map['isRefunded'] as bool,
      refundReason: map['refundReason'] as String?,
      refundSource: map['refundSource'] as String?,
      refundCreatorId: map['refundCreatorId'] as String?,
      transactionId: map['transactionId'] as int?,
      requestSourceId: map['requestSourceId'] as int,
      orderId: map['orderId'] as String?,
    );
  }

//</editor-fold>
}

class TransactionActions {
  final bool canRefund;
  final bool canVoid;
  final bool canCapture;
  final bool canPartialVoid;
  final bool canPartialRefund;

//<editor-fold desc="Data Methods">

  const TransactionActions({
    required this.canRefund,
    required this.canVoid,
    required this.canCapture,
    required this.canPartialVoid,
    required this.canPartialRefund,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionActions &&
          runtimeType == other.runtimeType &&
          canRefund == other.canRefund &&
          canVoid == other.canVoid &&
          canCapture == other.canCapture);

  @override
  int get hashCode =>
      canRefund.hashCode ^ canVoid.hashCode ^ canCapture.hashCode;

  TransactionActions copyWith({
    bool? canRefund,
    bool? canVoid,
    bool? canCapture,
    bool? canPartialVoid,
    bool? canPartialRefund,
  }) {
    return TransactionActions(
      canRefund: canRefund ?? this.canRefund,
      canVoid: canVoid ?? this.canVoid,
      canCapture: canCapture ?? this.canCapture,
      canPartialVoid: canPartialVoid ?? this.canPartialVoid,
      canPartialRefund: canPartialRefund ?? this.canPartialRefund,
    );
  }

  Map<String?, dynamic> toMap() {
    return {
      'canRefund': canRefund,
      'canVoid': canVoid,
      'canCapture': canCapture,
    };
  }

  factory TransactionActions.fromMap(Map<String?, dynamic> map) {
    return TransactionActions(
      canRefund: map['canRefund'] as bool,
      canVoid: map['canVoid'] as bool,
      canCapture: map['canCapture'] as bool,
      canPartialRefund: map['canPartialRefund'],
      canPartialVoid: map['canPartialVoid'],
    );
  }

//</editor-fold>
}
