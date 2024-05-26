class NetworkConstants {
  const NetworkConstants._();
  static String baseUrl = 'https://merchantapp.amwalpg.com/';
  static String baseUrlSdk = 'https://merchantapp.amwalpg.com:8443/';
  static const PRODUrlSdk = 'https://merchantapp.amwalpg.com:8443/';
  static const SITUrlSdk = 'https://test.amwalpg.com:22443/';
  static const UATUrlSdk = 'https://test.amwalpg.com:12443/';

  static String countryFlag(String countryCode) =>
      'https://flagsapi.com/$countryCode/shiny/32.png';

  static const getTransactionByIdEndpoint = '/Transaction/GetByTransactionId';
  static const getMerchantNameEndpoint = "/Merchant/GetMerchantDataForSDK";

  static const mockLabBaseUrl = 'https://amwalpayapi.mocklab.io/';
  static const isMockupMode = false;
  static bool isSdkInApp = false;

  static String get url => isSdkInApp ? baseUrlSdk : baseUrl;
}
