import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class SaleByWalletResponse extends BaseResponse<SaleByWalletData> {
  SaleByWalletResponse({
    required super.success,
    super.message,
    super.data,
  });

  factory SaleByWalletResponse.fromJson(dynamic json) {
    return SaleByWalletResponse(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? SaleByWalletData.fromMap(json['data']) : null,
    );
  }
}

class SaleByWalletData {
  final String messageIdentificationCode;
  final String numberOfTransactions;
  final String totalInterbankSettlementAmount;
  final String interbankSettlementDate;
  final String categoryPurposeProprietary;
  final String bicfi;
  final String endToEndId;
  final String trxnId;
  final String interBankSettlementAmount;
  final String senderName;
  final String senderId;
  final String receiverName;
  final String receiverId;
  final String senderIdentification;
  final String receiverIdentification;
  final String batchSource;
  final String groupMerchantId;
  final String terminalId;
  final String merchantName;
  final String createdDateTime;
  final int marchentOrderId;

//<editor-fold desc="Data Methods">

  const SaleByWalletData({
    required this.messageIdentificationCode,
    required this.numberOfTransactions,
    required this.totalInterbankSettlementAmount,
    required this.interbankSettlementDate,
    required this.categoryPurposeProprietary,
    required this.bicfi,
    required this.endToEndId,
    required this.trxnId,
    required this.interBankSettlementAmount,
    required this.senderName,
    required this.senderId,
    required this.receiverName,
    required this.receiverId,
    required this.senderIdentification,
    required this.receiverIdentification,
    required this.batchSource,
    required this.groupMerchantId,
    required this.terminalId,
    required this.merchantName,
    required this.createdDateTime,
    required this.marchentOrderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageIdentificationCode': messageIdentificationCode,
      'numberOfTransactions': numberOfTransactions,
      'totalInterbankSettlementAmount': totalInterbankSettlementAmount,
      'interbankSettlementDate': interbankSettlementDate,
      'categoryPurposeProprietary': categoryPurposeProprietary,
      'bicfi': bicfi,
      'endToEndId': endToEndId,
      'trxnId': trxnId,
      'interBankSettlementAmount': interBankSettlementAmount,
      'senderName': senderName,
      'senderId': senderId,
      'receiverName': receiverName,
      'receiverId': receiverId,
      'senderIdentification': senderIdentification,
      'receiverIdentification': receiverIdentification,
      'batchSource': batchSource,
      'groupMerchantId': groupMerchantId,
      'terminalId': terminalId,
      'merchantName': merchantName,
      'createdDateTime': createdDateTime,
      'marchentOrderId': marchentOrderId,
    };
  }

  factory SaleByWalletData.fromMap(Map<String, dynamic> map) {
    return SaleByWalletData(
      messageIdentificationCode: map['messageIdentificationCode'] as String,
      numberOfTransactions: map['numberOfTransactions'] as String,
      totalInterbankSettlementAmount:
          map['totalInterbankSettlementAmount'] as String,
      interbankSettlementDate: map['interbankSettlementDate'] as String,
      categoryPurposeProprietary: map['categoryPurposeProprietary'] as String,
      bicfi: map['bicfi'] as String,
      endToEndId: map['endToEndId'] as String,
      trxnId: map['trxnId'] as String,
      interBankSettlementAmount: map['interBankSettlementAmount'] as String,
      senderName: map['senderName'] as String,
      senderId: map['senderId'] as String,
      receiverName: map['receiverName'] as String,
      receiverId: map['receiverId'] as String,
      senderIdentification: map['senderIdentification'] as String,
      receiverIdentification: map['receiverIdentification'] as String,
      batchSource: map['batchSource'] as String,
      groupMerchantId: map['groupMerchantId'] as String,
      terminalId: map['terminalId'] as String,
      merchantName: map['merchantName'] as String,
      createdDateTime: map['createdDateTime'] as String,
      marchentOrderId: map['marchentOrderId'] as int,
    );
  }

//</editor-fold>
}
