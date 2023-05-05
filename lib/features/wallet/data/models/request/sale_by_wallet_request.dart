class SaleByWalletRequest {
  final String? mobileNumber;
  final String? alias;
  final String? terminalId;

  const SaleByWalletRequest({
    this.mobileNumber,
    this.alias,
    this.terminalId,
  });

  SaleByWalletRequest copyWith({
    String? mobileNumber,
    String? alias,
    String? terminalId,
  }) {
    return SaleByWalletRequest(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      alias: alias ?? this.alias,
      terminalId: terminalId ?? this.terminalId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobileNumber': mobileNumber,
      'alias': alias,
      'terminalId': terminalId,
    };
  }

  factory SaleByWalletRequest.fromMap(Map<String, dynamic> map) {
    return SaleByWalletRequest(
      mobileNumber: map['mobileNumber'] as String,
      alias: map['alias'] as String,
      terminalId: map['terminalId'] as String,
    );
  }
}
