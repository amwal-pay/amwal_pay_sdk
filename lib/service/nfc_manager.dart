import 'dart:convert';

import 'package:flutter/services.dart';

class NFCManager {
  const NFCManager._();

  static NFCManager get instance => const NFCManager._();

  static const MethodChannel _javaChannel = MethodChannel('com_amwalpay_sdk');

  Future<NFCStatus> initNFC() async {
    final result = await _javaChannel.invokeMethod('init');
    return NFCStatus.values[result];
  }

  Future<dynamic> startNFCScan() async {
    final scanOp = json.decode(await _javaChannel.invokeMethod("listen"));
    return scanOp;
  }

  Future<void> terminateNFC() async {
    final result = await _javaChannel.invokeMethod('terminate');
  }
}

enum NFCStatus {
  notAvailable,
  notEnabled,
  enabled,
}
