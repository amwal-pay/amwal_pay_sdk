import 'package:uuid/uuid.dart';

class WalletPaymentRequest {
  final int? transactionMethodId;
  final String? id;
  final int currencyId;
  final num amount;
  final String terminalId;
  final String? mobileNumber;
  final String? aliasName;
  final int merchantId;
  final String transactionId;

  const WalletPaymentRequest({
    required this.currencyId,
    required this.amount,
    required this.terminalId,
    required this.merchantId,
    required this.transactionId,
    this.id,
    this.transactionMethodId,
    this.mobileNumber,
    this.aliasName,
  });

  Map<String, dynamic> payWithMobileNumber() {
    return {
      'amount': amount,
      'currencyId': currencyId,
      'id': id,
      'mobileNumber': mobileNumber,
      'transactionMethodId': 5,
      'uniqueNotificationId': transactionId,
      'merchantId': merchantId.toString(),
      'terminalId': terminalId,
    };
  }

  Map<String, dynamic> payWithAliasName() {
    return {
      'transactionMethodId': 6,
      'currencyId': currencyId,
      'terminalId': terminalId,
      'merchantId': merchantId.toString(),
      'id': id,
      'aliasName': aliasName,
      'amount': amount,
      'uniqueNotificationId': transactionId,
    };
  }

  Map<String, dynamic> payWithQrCode() {
    return {
      // 'requestDateTime': DateTime.now().toIso8601String(),
      'CurrencyId': currencyId,
      'TerminalId': terminalId,
      'MerchantId': merchantId,
      'Id': id,
      'dataProvider': 1,
      'Amount': amount,
    };
  }
}
