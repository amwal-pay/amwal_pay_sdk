enum TransactionType {
  nfc,
  cardWallet,
  appleOrGooglePay;

  bool get isSoftPOS => this == TransactionType.nfc;
}
