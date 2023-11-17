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
      'TransactionMethodId': 5,
      'MobileNumber': mobileNumber,
      'CurrencyId': currencyId,
      'merchantId': merchantId.toString(),
      'TerminalId': terminalId,
      'Id': id,
      'UniqueNotificationId': transactionId,
      'Amount': amount,
    };
  }

  Map<String, dynamic> payWithAliasName() {
    return {
      'TransactionMethodId': 6,
      'CurrencyId': currencyId,
      'TerminalId': terminalId,
      'merchantId': merchantId.toString(),
      'Id': id,
      'AliasName': aliasName,
      'Amount': amount,
      'UniqueNotificationId': transactionId,
    };
  }

  Map<String, dynamic> payWithQrCode() {
    return {
      'requestDateTime': DateTime.now().toIso8601String(),
      'CurrencyId': currencyId,
      'TerminalId': terminalId,
      'MerchantId': merchantId,
      'Id': id,
      'dataProvider': 1,
      'Amount': amount,
    };
  }
}
