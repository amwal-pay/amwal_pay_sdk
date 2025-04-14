import 'package:pay/pay.dart';

/// Constants for digital wallet payment configuration
class DigitalWalletConstants {

  // Apple Pay configuration
  static const String applePayConfigString = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.applepay.amwalpay",
    "displayName": "Amwal",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "OM",
    "currencyCode": "OMR",
    "requiredBillingContactFields": [],
    "requiredShippingContactFields": []
  }
}''';

  // Google Pay configuration
  static const String googlePayConfigString = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "amwal",
            "gatewayMerchantId": "01234567890123456789"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD", "AMEX", "DISCOVER", "JCB", "MAESTRO", "ELECTRON", "CARTES_BANCAIRES", "UNIONPAY", "EFTPOS", "ELO", "ID_CREDIT", "MADA", "PRIVATE_LABEL", "QUICPAY", "SUICA", "V_PAY"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantName": "Amwal"
    },
    "transactionInfo": {
      "countryCode": "OM",
      "currencyCode": "OMR"
    }
  }
}''';
}
