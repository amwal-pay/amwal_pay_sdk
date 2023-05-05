class WalletPaymentRequest {
  final int transactionMethodId;
  final String orderKey;
  final String processingCode;
  final int currencyId;
  final String id;
  final num amount;
  final String terminalId;
  final String? mobileNumber;
  final String? aliasName;

  const WalletPaymentRequest({
    required this.transactionMethodId,
    required this.orderKey,
    required this.processingCode,
    required this.currencyId,
    required this.id,
    required this.amount,
    required this.terminalId,
    this.mobileNumber,
    this.aliasName,
  });

  Map<String, dynamic> payWithMobileNumber() {
    return {
      'TransactionMethodId': transactionMethodId,
      'OrderKey': orderKey,
      'ProcessingCode': processingCode,
      'CurrencyId': currencyId,
      'Id': id,
      'Amount': amount,
      'TerminalId': terminalId,
      'MobileNumber': mobileNumber,
    };
  }

  Map<String, dynamic> payWithAliasName() {
    return {
      'TransactionMethodId': transactionMethodId,
      'OrderKey': orderKey,
      'ProcessingCode': processingCode,
      'CurrencyId': currencyId,
      'Id': id,
      'Amount': amount,
      'TerminalId': terminalId,
      'AliasName': aliasName,
    };
  }

  Map<String, dynamic> payWithQrCode() {
    return {
      'TransactionMethodId': transactionMethodId,
      'OrderKey': orderKey,
      'ProcessingCode': processingCode,
      'CurrencyId': currencyId,
      'Id': id,
      'Amount': amount,
      'TerminalId': terminalId,
      'AliasName': aliasName,
    };
  }
}
