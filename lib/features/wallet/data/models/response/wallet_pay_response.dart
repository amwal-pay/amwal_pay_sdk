import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class WalletPayResponse extends BaseResponse<WalletPayData> {
  WalletPayResponse({
    required super.success,
    super.responseCode,
    super.message,
    super.data,
  });

  factory WalletPayResponse.fromJson(dynamic json) {
    return WalletPayResponse(
      success: json['success'],
      message: json['message'],
      responseCode: int.tryParse(json['responseCode']),
      data: WalletPayData.fromMap(
        json['data'],
      ),
    );
  }
}

class WalletPayData {
  final String id;
  final int idN;
  final String from;
  final String? to;
  final int merchantRefId;
  final int terminalNodeId;
  final int bankId;
  final num amount;
  final int currencyId;
  final String createdDateTime;
  final String maxResponseDatetime;
  final String? aggregatorId;
  final int merchantAccountTypeId;
  final String status;
  final String? transactionSource;
  final int transactionTypeId;
  final String externalTransactionId;
  final String? originalExternalTransactionId;
  final String senderMobileNo;
  final String? receiverMobileNo;
  final int transactionMethodId;
  final int? originalTransactionId;
  final int? originalDigitalTransactionId;
  final String? senderName;
  final String? senderAddress;
  final String? receiverName;
  final String? receiverAddress;
  final String? senderReferenceNo;
  final bool isRefunded;
  final String? refundReason;
  final String? refundSource;
  final String? refundCreatorId;
  final String transactionIdentifier;
  final String orderId;
  final String? transactionId;
  final String? merchantBranchId;
  final String? transactionViewModel;
  final String? digitalTransactionEnquiryViewModel;
  final int merchantId;
  final int terminalId;
  final String? responseCode;
  final String? rowVersion;

//<editor-fold desc="Data Methods">
  const WalletPayData({
    required this.id,
    required this.idN,
    required this.from,
    this.to,
    required this.merchantRefId,
    required this.terminalNodeId,
    required this.bankId,
    required this.amount,
    required this.currencyId,
    required this.createdDateTime,
    required this.maxResponseDatetime,
    this.aggregatorId,
    required this.merchantAccountTypeId,
    required this.status,
    this.transactionSource,
    required this.transactionTypeId,
    required this.externalTransactionId,
    this.originalExternalTransactionId,
    required this.senderMobileNo,
    this.receiverMobileNo,
    required this.transactionMethodId,
    this.originalTransactionId,
    this.originalDigitalTransactionId,
    this.senderName,
    this.senderAddress,
    this.receiverName,
    this.receiverAddress,
    this.senderReferenceNo,
    required this.isRefunded,
    this.refundReason,
    this.refundSource,
    this.refundCreatorId,
    required this.transactionIdentifier,
    required this.orderId,
    this.transactionId,
    this.merchantBranchId,
    this.transactionViewModel,
    this.digitalTransactionEnquiryViewModel,
    required this.merchantId,
    required this.terminalId,
    this.responseCode,
    this.rowVersion,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletPayData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          idN == other.idN &&
          from == other.from &&
          to == other.to &&
          merchantRefId == other.merchantRefId &&
          terminalNodeId == other.terminalNodeId &&
          bankId == other.bankId &&
          amount == other.amount &&
          currencyId == other.currencyId &&
          createdDateTime == other.createdDateTime &&
          maxResponseDatetime == other.maxResponseDatetime &&
          aggregatorId == other.aggregatorId &&
          merchantAccountTypeId == other.merchantAccountTypeId &&
          status == other.status &&
          transactionSource == other.transactionSource &&
          transactionTypeId == other.transactionTypeId &&
          externalTransactionId == other.externalTransactionId &&
          originalExternalTransactionId ==
              other.originalExternalTransactionId &&
          senderMobileNo == other.senderMobileNo &&
          receiverMobileNo == other.receiverMobileNo &&
          transactionMethodId == other.transactionMethodId &&
          originalTransactionId == other.originalTransactionId &&
          originalDigitalTransactionId == other.originalDigitalTransactionId &&
          senderName == other.senderName &&
          senderAddress == other.senderAddress &&
          receiverName == other.receiverName &&
          receiverAddress == other.receiverAddress &&
          senderReferenceNo == other.senderReferenceNo &&
          isRefunded == other.isRefunded &&
          refundReason == other.refundReason &&
          refundSource == other.refundSource &&
          refundCreatorId == other.refundCreatorId &&
          transactionIdentifier == other.transactionIdentifier &&
          orderId == other.orderId &&
          transactionId == other.transactionId &&
          merchantBranchId == other.merchantBranchId &&
          transactionViewModel == other.transactionViewModel &&
          digitalTransactionEnquiryViewModel ==
              other.digitalTransactionEnquiryViewModel &&
          merchantId == other.merchantId &&
          terminalId == other.terminalId &&
          responseCode == other.responseCode &&
          rowVersion == other.rowVersion);

  @override
  int get hashCode =>
      id.hashCode ^
      idN.hashCode ^
      from.hashCode ^
      to.hashCode ^
      merchantRefId.hashCode ^
      terminalNodeId.hashCode ^
      bankId.hashCode ^
      amount.hashCode ^
      currencyId.hashCode ^
      createdDateTime.hashCode ^
      maxResponseDatetime.hashCode ^
      aggregatorId.hashCode ^
      merchantAccountTypeId.hashCode ^
      status.hashCode ^
      transactionSource.hashCode ^
      transactionTypeId.hashCode ^
      externalTransactionId.hashCode ^
      originalExternalTransactionId.hashCode ^
      senderMobileNo.hashCode ^
      receiverMobileNo.hashCode ^
      transactionMethodId.hashCode ^
      originalTransactionId.hashCode ^
      originalDigitalTransactionId.hashCode ^
      senderName.hashCode ^
      senderAddress.hashCode ^
      receiverName.hashCode ^
      receiverAddress.hashCode ^
      senderReferenceNo.hashCode ^
      isRefunded.hashCode ^
      refundReason.hashCode ^
      refundSource.hashCode ^
      refundCreatorId.hashCode ^
      transactionIdentifier.hashCode ^
      orderId.hashCode ^
      transactionId.hashCode ^
      merchantBranchId.hashCode ^
      transactionViewModel.hashCode ^
      digitalTransactionEnquiryViewModel.hashCode ^
      merchantId.hashCode ^
      terminalId.hashCode ^
      responseCode.hashCode ^
      rowVersion.hashCode;

  WalletPayData copyWith({
    String? id,
    int? idN,
    String? from,
    String? to,
    int? merchantRefId,
    int? terminalNodeId,
    int? bankId,
    num? amount,
    int? currencyId,
    String? createdDateTime,
    String? maxResponseDatetime,
    String? aggregatorId,
    int? merchantAccountTypeId,
    String? status,
    String? transactionSource,
    int? transactionTypeId,
    String? externalTransactionId,
    String? originalExternalTransactionId,
    String? senderMobileNo,
    String? reciverMobileNo,
    int? transactionMethodId,
    int? originalTransactionId,
    int? originalDigitalTransactionId,
    String? senderName,
    String? senderAddress,
    String? receiverName,
    String? receiverAddress,
    String? senderReferenceNo,
    bool? isRefunded,
    String? refundReason,
    String? refundSource,
    String? refundCreatorId,
    String? transactionIdentifier,
    String? orderId,
    String? transactionId,
    String? merchantBranchId,
    String? transactionViewModel,
    String? digitalTransactionEnquiryViewModel,
    int? merchantId,
    int? terminalId,
    String? responseCode,
    String? rowVersion,
  }) {
    return WalletPayData(
      id: id ?? this.id,
      idN: idN ?? this.idN,
      from: from ?? this.from,
      to: to ?? this.to,
      merchantRefId: merchantRefId ?? this.merchantRefId,
      terminalNodeId: terminalNodeId ?? this.terminalNodeId,
      bankId: bankId ?? this.bankId,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      createdDateTime: createdDateTime ?? this.createdDateTime,
      maxResponseDatetime: maxResponseDatetime ?? this.maxResponseDatetime,
      aggregatorId: aggregatorId ?? this.aggregatorId,
      merchantAccountTypeId:
          merchantAccountTypeId ?? this.merchantAccountTypeId,
      status: status ?? this.status,
      transactionSource: transactionSource ?? this.transactionSource,
      transactionTypeId: transactionTypeId ?? this.transactionTypeId,
      externalTransactionId:
          externalTransactionId ?? this.externalTransactionId,
      originalExternalTransactionId:
          originalExternalTransactionId ?? this.originalExternalTransactionId,
      senderMobileNo: senderMobileNo ?? this.senderMobileNo,
      receiverMobileNo: reciverMobileNo ?? this.receiverMobileNo,
      transactionMethodId: transactionMethodId ?? this.transactionMethodId,
      originalTransactionId:
          originalTransactionId ?? this.originalTransactionId,
      originalDigitalTransactionId:
          originalDigitalTransactionId ?? this.originalDigitalTransactionId,
      senderName: senderName ?? this.senderName,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverName: receiverName ?? this.receiverName,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      senderReferenceNo: senderReferenceNo ?? this.senderReferenceNo,
      isRefunded: isRefunded ?? this.isRefunded,
      refundReason: refundReason ?? this.refundReason,
      refundSource: refundSource ?? this.refundSource,
      refundCreatorId: refundCreatorId ?? this.refundCreatorId,
      transactionIdentifier:
          transactionIdentifier ?? this.transactionIdentifier,
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
      merchantBranchId: merchantBranchId ?? this.merchantBranchId,
      transactionViewModel: transactionViewModel ?? this.transactionViewModel,
      digitalTransactionEnquiryViewModel: digitalTransactionEnquiryViewModel ??
          this.digitalTransactionEnquiryViewModel,
      merchantId: merchantId ?? this.merchantId,
      terminalId: terminalId ?? this.terminalId,
      responseCode: responseCode ?? this.responseCode,
      rowVersion: rowVersion ?? this.rowVersion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idN': idN,
      'from': from,
      'to': to,
      'merchantRefId': merchantRefId,
      'terminalNodeId': terminalNodeId,
      'bankId': bankId,
      'amount': amount,
      'currencyId': currencyId,
      'createdDateTime': createdDateTime,
      'maxResponseDatetime': maxResponseDatetime,
      'aggregatorId': aggregatorId,
      'merchantAccountTypeId': merchantAccountTypeId,
      'status': status,
      'transactionSource': transactionSource,
      'transactionTypeId': transactionTypeId,
      'externalTransactionId': externalTransactionId,
      'originalExternalTransactionId': originalExternalTransactionId,
      'senderMobileNo': senderMobileNo,
      'receiverMobileNo': receiverMobileNo,
      'transactionMethodId': transactionMethodId,
      'originalTransactionId': originalTransactionId,
      'originalDigitalTransactionId': originalDigitalTransactionId,
      'senderName': senderName,
      'senderAddress': senderAddress,
      'receiverName': receiverName,
      'receiverAddress': receiverAddress,
      'senderReferenceNo': senderReferenceNo,
      'isRefunded': isRefunded,
      'refundReason': refundReason,
      'refundSource': refundSource,
      'refundCreatorId': refundCreatorId,
      'transactionIdentifier': transactionIdentifier,
      'orderId': orderId,
      'transactionId': transactionId,
      'merchantBranchId': merchantBranchId,
      'transactionViewModel': transactionViewModel,
      'digitalTransactionEnquiryViewModel': digitalTransactionEnquiryViewModel,
      'merchantId': merchantId,
      'terminalId': terminalId,
      'responseCode': responseCode,
      'rowVersion': rowVersion,
    };
  }

  factory WalletPayData.fromMap(Map<String, dynamic> map) {
    return WalletPayData(
      id: map['id'] as String,
      idN: map['idN'] as int,
      from: map['from'] as String,
      to: map['to'] as String?,
      merchantRefId: map['merchantRefId'] as int,
      terminalNodeId: map['terminalNodeId'] as int,
      bankId: map['bankId'] as int,
      amount: map['amount'] as num,
      currencyId: map['currencyId'] as int,
      createdDateTime: map['createdDatetime'] as String,
      maxResponseDatetime: map['maxResponseDatetime'] as String,
      aggregatorId: map['aggregatorId'] as String?,
      merchantAccountTypeId: map['merchantAccountTypeId'] as int,
      status: map['status'] as String,
      transactionSource: map['transactionSource'] as String?,
      transactionTypeId: map['transactionTypeId'] as int,
      externalTransactionId: map['externalTransactionId'] as String,
      originalExternalTransactionId:
          map['originalExternalTransactionId'] as String?,
      senderMobileNo: map['senderMobileNo'] as String,
      receiverMobileNo: map['receiverMobileNo'] as String?,
      transactionMethodId: map['transactionMethodId'] as int,
      originalTransactionId: map['originalTransactionId'] as int?,
      originalDigitalTransactionId: map['originalDigitalTransactionId'] as int?,
      senderName: map['senderName'] as String?,
      senderAddress: map['senderAddress'] as String?,
      receiverName: map['receiverName'] as String?,
      receiverAddress: map['receiverAddress'] as String?,
      senderReferenceNo: map['senderReferenceNo'] as String?,
      isRefunded: map['isRefunded'] as bool,
      refundReason: map['refundReason'] as String?,
      refundSource: map['refundSource'] as String?,
      refundCreatorId: map['refundCreatorId'] as String?,
      transactionIdentifier: map['transactionIdentifier'] as String,
      orderId: map['orderId'] as String,
      transactionId: map['transactionId'] as String?,
      merchantBranchId: map['merchantBranchId'] as String?,
      transactionViewModel: map['transactionViewModel'] as String?,
      digitalTransactionEnquiryViewModel:
          map['digitalTransactionEnquiryViewModel'] as String?,
      merchantId: map['merchantId'] as int,
      terminalId: map['terminalId'] as int,
      responseCode: map['responseCode'] as String?,
      rowVersion: map['rowVersion'] as String?,
    );
  }

//</editor-fold>
}
