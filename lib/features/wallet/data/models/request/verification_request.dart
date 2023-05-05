class WalletMobileVerificationRequest {
  final String mobileNumber;
  final String alias;
  final num amount;
  final int currencyId;
  final String terminalId;
  final String merchantOrderId;
  final String messageIdentificationCode;
  final String instructingAlias;
  final String instructingMobile;
  final String id;

//<editor-fold desc="Data Methods">

  const WalletMobileVerificationRequest({
    required this.mobileNumber,
    required this.alias,
    required this.amount,
    required this.currencyId,
    required this.terminalId,
    required this.merchantOrderId,
    required this.messageIdentificationCode,
    required this.instructingAlias,
    required this.instructingMobile,
    required this.id,
  });

// {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletMobileVerificationRequest &&
          runtimeType == other.runtimeType &&
          mobileNumber == other.mobileNumber &&
          alias == other.alias &&
          amount == other.amount &&
          currencyId == other.currencyId &&
          terminalId == other.terminalId &&
          merchantOrderId == other.merchantOrderId &&
          messageIdentificationCode == other.messageIdentificationCode &&
          instructingAlias == other.instructingAlias &&
          instructingMobile == other.instructingMobile);

// "MobileNumber": "23 123456@override
  int get hashCode =>
      mobileNumber.hashCode ^
      alias.hashCode ^
      amount.hashCode ^
      currencyId.hashCode ^
      terminalId.hashCode ^
      merchantOrderId.hashCode ^
      messageIdentificationCode.hashCode ^
      instructingAlias.hashCode ^
      instructingMobile.hashCode;

  WalletMobileVerificationRequest copyWith({
    String? mobileNumber,
    String? alias,
    num? amount,
    int? currencyId,
    int? merchantId,
    String? terminalId,
    String? merchantOrderId,
    String? messageIdentificationCode,
    String? instructingAlias,
    String? instructingMobile,
    String? id,
  }) {
    return WalletMobileVerificationRequest(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      alias: alias ?? this.alias,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      terminalId: terminalId ?? this.terminalId,
      merchantOrderId: merchantOrderId ?? this.merchantOrderId,
      messageIdentificationCode:
          messageIdentificationCode ?? this.messageIdentificationCode,
      instructingAlias: instructingAlias ?? this.instructingAlias,
      instructingMobile: instructingMobile ?? this.instructingMobile,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MobileNumber': mobileNumber,
      'Alias': alias,
      'amount': amount,
      'currencyId': currencyId,
      'terminalId': terminalId,
      'MerchantOrderId': merchantOrderId,
      'MessageIdentificationCode': messageIdentificationCode,
      'InstructingAlias': instructingAlias,
      'InstructingMobile': instructingMobile,
    };
  }
}
