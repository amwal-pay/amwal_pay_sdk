import 'package:flutter_pay/flutter_pay.dart';

/// Constants for digital wallet payment configuration
class DigitalWalletConstants {
  static const String countryCode = "OM";
  static const String currencyCode = "OMR";
  static const String merchantIdentifier = "merchant.applepay.amwalpay";
  static const String merchantName = 'Amwal';
  static final List<PaymentNetwork> supportedNetworks = [
    PaymentNetwork.visa,
    PaymentNetwork.masterCard,
    PaymentNetwork.amex,
    PaymentNetwork.interac,
    PaymentNetwork.discover,
    PaymentNetwork.jcb,
    PaymentNetwork.maestro,
    PaymentNetwork.electron,
    PaymentNetwork.cartesBancarries,
    PaymentNetwork.unionPay,
    PaymentNetwork.eftPos,
    PaymentNetwork.elo,
    PaymentNetwork.idCredit,
    PaymentNetwork.mada,
    PaymentNetwork.privateLabel,
    PaymentNetwork.quicPay,
    PaymentNetwork.suica,
    PaymentNetwork.vPay,
  ];
}
