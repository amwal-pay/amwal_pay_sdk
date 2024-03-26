class NetworkConstants {
  const NetworkConstants._();
  static String baseUrl = 'https://merchantapp.amwalpg.com/';
  static const baseUrlSdk = 'https://merchantapp.amwalpg.com:8443/';

  static const getTransactionByIdEndpoint = '/Transaction/GetByTransactionId';
  static const getMerchantNameEndpoint = "/Merchant/GetMerchantName";

  static const mockLabBaseUrl = 'https://amwalpayapi.mocklab.io/';
  static const isMockupMode = false;
  static bool isSdkInApp = false;

  static String get url => isSdkInApp ? baseUrlSdk : baseUrl;
}
