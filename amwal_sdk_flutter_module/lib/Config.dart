
import 'dart:convert';
import 'dart:ffi';

class Config {
  final String environment;
  final String sessionToken;
  final String currency;
  final String amount;
  final String merchantId;
  final String terminalId;
  final String? customerId;
  final String locale;
  final bool isSoftPOS;

  Config({
    required this.environment,
    required this.sessionToken,
    required this.currency,
    required this.amount,
    required this.merchantId,
    required this.terminalId,
    this.customerId,
    required this.locale,
    required this.isSoftPOS,
  });

  // Convert JSON string to Config object
  factory Config.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Config(
      environment: jsonMap['environment'],
      sessionToken: jsonMap['sessionToken'],
      currency: jsonMap['currency'],
      amount: jsonMap['amount'],
      merchantId: jsonMap['merchantId'],
      terminalId: jsonMap['terminalId'],
      customerId: jsonMap['customerId'] as String?,
      locale: jsonMap['locale'],
      isSoftPOS: jsonMap['isSoftPOS'],
    );
  }

}
