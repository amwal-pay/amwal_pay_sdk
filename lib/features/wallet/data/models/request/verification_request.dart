import 'package:uuid/uuid.dart';

class WalletMobileVerificationRequest {
  final String mobileNumber;
  final String alias;
  final num amount;
  final int currencyId;
  final String terminalId;
  final int merchantId;
  final String? id;

//<editor-fold desc="Data Methods">

  const WalletMobileVerificationRequest({
    required this.mobileNumber,
    required this.alias,
    required this.amount,
    required this.currencyId,
    required this.terminalId,
    required this.merchantId,
      this.id,
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
          merchantId == other.merchantId);

// "MobileNumber": "23 123456@override
  @override
  int get hashCode =>
      mobileNumber.hashCode ^
      alias.hashCode ^
      amount.hashCode ^
      currencyId.hashCode ^
      terminalId.hashCode ^
      merchantId.hashCode;

  WalletMobileVerificationRequest copyWith({
    String? mobileNumber,
    String? alias,
    num? amount,
    int? currencyId,
    int? merchantId,
    String? terminalId,
    String? id,
  }) {
    return WalletMobileVerificationRequest(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      alias: alias ?? this.alias,
      amount: amount ?? this.amount,
      currencyId: currencyId ?? this.currencyId,
      terminalId: terminalId ?? this.terminalId,
      merchantId: merchantId ?? this.merchantId,
      id: id??this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Alias': alias,
      'amount': amount,
      'mobileNumber': mobileNumber,
      'currencyId': currencyId,
      'merchantId': merchantId,
      'terminalId': terminalId,
      'uniqueNotificationId': id,
    }..removeWhere((key, value) => value == null || value == '');
  }
}
