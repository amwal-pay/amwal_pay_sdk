class NetworkConstants {
  const NetworkConstants._();
  static String baseUrl = 'https://merchantapp.amwalpg.com/';
  static String baseUrlSdk = 'https://merchantapp.amwalpg.com:8443/';
  static const _PRODUrlSdk = 'https://merchantapp.amwalpg.com:8443/';
  static const _SITUrlSdk = 'https://test.amwalpg.com:22443/';
  static const _UATUrlSdk = 'https://test.amwalpg.com:12443/';

  static String countryFlag(String countryCode) =>
      'https://flagsapi.com/$countryCode/shiny/32.png';

  static const getTransactionByIdEndpoint = '/Transaction/GetByTransactionId';
  static const getMerchantNameEndpoint = "/Merchant/GetMerchantDataForSDK";
  static const getSDKSessionToken = "Membership/GetSDKSessionToken";
  static const getCustomerTokens = "/Customer/GetCustomerTokens";

  static const mockLabBaseUrl = 'https://amwalpayapi.mocklab.io/';
  static const isMockupMode = false;
  static bool isSdkInApp = false;

  static String get url => isSdkInApp ? baseUrlSdk : baseUrl;

  static void setEnvironment(Environment environment) {
    switch (environment) {
      case Environment.UAT:
        NetworkConstants.baseUrlSdk = _UATUrlSdk;
        break;
      case Environment.SIT:
        NetworkConstants.baseUrlSdk =_SITUrlSdk;
        break;
      case Environment.PROD:
        NetworkConstants.baseUrlSdk = _PRODUrlSdk;
        break;
    }
  }

}
enum Environment { UAT, SIT, PROD }
