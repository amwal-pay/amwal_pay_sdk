import 'package:uuid/uuid.dart';

class WalletPaymentRequest {
  final int? transactionMethodId;
  final String? orderKey;
  final String? id;
  final String processingCode;
  final int currencyId;
  final num amount;
  final String terminalId;
  final String? mobileNumber;
  final String? aliasName;
  final int merchantId;

  const WalletPaymentRequest({
    required this.processingCode,
    required this.currencyId,
    required this.amount,
    required this.terminalId,
    required this.merchantId,
    this.id,
    this.transactionMethodId,
    this.mobileNumber,
    this.aliasName,
    this.orderKey,
  });

  Map<String, dynamic> payWithMobileNumber() {
    return {
      'TransactionMethodId': 5,
      'ProcessingCode': processingCode,
      'MobileNumber': mobileNumber,
      'CurrencyId': currencyId,
      'MerchantId': merchantId,
      'TerminalId': terminalId,
      'Id': id,
      'UniqueNotificationId': const Uuid().v1(),
      'OrderKey': orderKey,
      'Amount': amount,
    };
  }

  Map<String, dynamic> payWithAliasName() {
    return {
      'TransactionMethodId': 6,
      'ProcessingCode': processingCode,
      'CurrencyId': currencyId,
      'TerminalId': terminalId,
      'MerchantId': merchantId,
      'Id': id,
      'AliasName': aliasName,
      'OrderKey': orderKey,
      'Amount': amount,
    };
  }

  Map<String, dynamic> payWithQrCode() {
    return {
      'requestDateTime': DateTime.now().toIso8601String(),
      'ProcessingCode': processingCode,
      'CurrencyId': currencyId,
      'TerminalId': terminalId,
      'MerchantId': merchantId,
      'Id': id,
      'dataProvider': 1,
      'Amount': amount,
    };
  }
}
