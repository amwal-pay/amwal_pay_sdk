class SaleByWalletConstant {
  SaleByWalletConstant._();
  static const saleByWalletEndpoint = 'DigitalTransaction/DebitPaymentRequest';
  static const saleByQREndpoint = '/QRCode/GenerateIsoQRCode';
  static const verifyCustomerEndpoint =
      'DigitalOperation/CustomerNameVerificationRequest';

  static const qrMockup = 'assets/json/mockups/salebywallet/qr_response.json';

  static const saleByWalletFailedMockup =
      'assets/json/mockups/login/failed.json';
  static const saleByWalletSuccessMockup =
      'assets/json/mockups/salebywallet/success.json';
  static const verifyCustomerSuccessMockup =
      'assets/json/mockups/salebywallet/verify_customer_success.json';
}
