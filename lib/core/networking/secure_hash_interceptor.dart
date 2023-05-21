import 'dart:convert';

import 'package:amwal_pay_sdk/core/merchant_store/merchant_store.dart';
import 'package:amwal_pay_sdk/features/card/domain/sale_by_card_constants.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SecureHashInterceptor extends Interceptor {
  final String secureHashValue;

  SecureHashInterceptor({
    required this.secureHashValue,
  });


  Map<String, dynamic> _voidHandleTerminalId(RequestOptions options) {
    final data = options.data as Map<String, dynamic>;
    return data;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = _voidHandleTerminalId(options);
    final terminals = MerchantStore.instance.getTerminal();
    final merchantId = MerchantStore.instance.getMerchantId();
    options.headers['Accept'] = '*/*';
    if (terminals.length == 1) {
      data.addAll({
        'terminalId': terminals.single,
      });
    }
    String secureHashVal = clearSecureHash(secureHashValue, convertMap(data));
    data.addAll({
      'secureHashValue': secureHashVal,
    });
    // 'merchantRefId': merchantId,

    final interceptedOptions = options.copyWith(data: data);
    super.onRequest(interceptedOptions, handler);
  }

  Map<String, String> convertMap(Map<String, dynamic> originalMap) {
    Map<String, String> convertedMap = {};

    originalMap.forEach((key, value) {
      if (value is String) {
        convertedMap[key] = value;
      } else if (value != null) {
        convertedMap[key] = value.toString();
      }
    });

    return convertedMap;
  }

  String clearSecureHash(String secretKey, Map<String, String> data) {
    // Convert Request DateTime found into APG Date format.
    if (data.containsKey('requestDateTime')) {
      var date = DateTime.parse(data['requestDateTime']!);
      data['requestDateTime'] = DateFormat('yyyyMMddHHmmss').format(date);
    }
    // Convert any DateTime found into APG Date Format.
    data.forEach((key, value) {
      if (!key.toLowerCase().contains('datetime')) return;

      DateTime datetime;
      if (DateTime.tryParse(value) != null) {
        datetime = DateTime.parse(value);
        data[key] = DateFormat('yyyyMMddHHmmss').format(datetime);
      }
    });
    // Remove Secure Hash Value from the model
    data.remove('secureHashValue');

    String concatedString = composeData(data);
    return generateSecureHash(concatedString, secretKey);
  }

  String composeData(Map<String, String> requestParameters) {
    try {
      if (requestParameters.isEmpty) return '';

      // The field names are sorted in ascending order of the parameter name.
      var sortedParameters = requestParameters.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Remove null values
      sortedParameters.removeWhere((entry) => entry.value.isEmpty);

      return sortedParameters
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&');
    } catch (ex) {
      return '';
    }
  }

  String generateSecureHash(String message, String secretKey) {
    try {
      final key = hex.decode(secretKey); // Convert hex key to bytes

      final hmacSha256 = Hmac(sha256, key); // Create HMAC-SHA256 object
      final signature =
          hmacSha256.convert(utf8.encode(message)); // Generate signature

      print('Message: $message');
      print('Key: ${hex.encode(key)}'); // Convert bytes back to hex
      print('Signature: ${hex.encode(signature.bytes)}'); //
      return hex.encode(signature.bytes).toUpperCase();
    } catch (ex) {
      return '';
    }
  }
}
