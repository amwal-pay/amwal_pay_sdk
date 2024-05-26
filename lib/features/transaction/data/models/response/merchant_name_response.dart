import 'package:amwal_pay_sdk/core/base_response/base_response.dart';

class MerchantDataResponse extends BaseResponse<MerchantData?> {
  MerchantDataResponse({
    required super.success,
    super.data,
    super.message,
  });

  factory MerchantDataResponse.fromJson(dynamic json) {
    return MerchantDataResponse(
      success: json['success'],
      message: json['message'],
      data: MerchantData.fromJson(json['data']),
    );
  }
}

class MerchantData {
  final String merchantName;
  final TerminalData terminalData;

  MerchantData({required this.merchantName, required this.terminalData});

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      merchantName: json['merchantName'],
      terminalData: TerminalData.fromJson(json['terminalData']),
    );
  }

  toJson() {
    return {
      'merchantName': merchantName,
      'terminalData': terminalData.toJson(),
    };
  }
}

class TerminalData {
  final int nodeId;
  final int terminalId;
  final String name;
  final String terminalTypeName;
  final int terminalTypeId;
  final bool isCard;
  final bool isWallet;
  final bool canCardTransaction;
  final bool canWalletTransaction;

  TerminalData({
    required this.nodeId,
    required this.terminalId,
    required this.name,
    required this.terminalTypeName,
    required this.terminalTypeId,
    required this.isCard,
    required this.isWallet,
    required this.canCardTransaction,
    required this.canWalletTransaction,
  });

  factory TerminalData.fromJson(Map<String, dynamic> json) {
    return TerminalData(
      nodeId: json['nodeId'],
      terminalId: json['terminalId'],
      name: json['name'],
      terminalTypeName: json['terminalTypeName'],
      terminalTypeId: json['terminalTypeId'],
      isCard: json['isCard'],
      isWallet: json['isWallet'],
      canCardTransaction: json['canCardTransaction'],
      canWalletTransaction: json['canWalletTransaction'],
    );
  }

  toJson() {
    return {
      'nodeId': nodeId,
      'terminalId': terminalId,
      'name': name,
      'terminalTypeName': terminalTypeName,
      'terminalTypeId': terminalTypeId,
      'isCard': isCard,
      'isWallet': isWallet,
      'canCardTransaction': canCardTransaction,
      'canWalletTransaction': canWalletTransaction,
    };
  }
}
