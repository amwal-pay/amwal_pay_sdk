class SDKNetworkConstants {
  const SDKNetworkConstants._();

  static String _baseUrl = 'https://merchantapp.amwalpg.com/';
  static String _baseUrlSdk = 'https://merchantapp.amwalpg.com:8443/';
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

  static String get url => isSdkInApp ? _baseUrlSdk : _baseUrl;

  static void setEnvironment( {Environment? environment,String? baseUrl}) {
    if (isSdkInApp) {
      switch (environment ?? Environment.PROD) {
        case Environment.UAT:
          SDKNetworkConstants._baseUrlSdk = _UATUrlSdk;
          break;
        case Environment.SIT:
          SDKNetworkConstants._baseUrlSdk = _SITUrlSdk;
          break;
        case Environment.PROD:
          SDKNetworkConstants._baseUrlSdk = _PRODUrlSdk;
          break;
      }
    }
    else {
      _baseUrl = baseUrl ?? url ;
      _baseUrlSdk = baseUrl ?? url;
    }
  }
}
enum Environment { UAT, SIT, PROD }


extension EnvironmentExtension on Environment {
  static Environment fromString(String environment) {
    switch (environment.toUpperCase()) {
      case 'UAT':
        return Environment.UAT;
      case 'SIT':
        return Environment.SIT;
      case 'PROD':
        return Environment.PROD;
      default:
        throw ArgumentError('Invalid environment: $environment');
    }
  }
}