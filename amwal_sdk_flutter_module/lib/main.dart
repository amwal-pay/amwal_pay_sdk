import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'Config.dart';
import 'RootNavigatorObserver.dart';
import 'package:amwal_pay_sdk/core/enums/transaction_type.dart';

const platform = MethodChannel('amwal.sdk/functions');

void main(List<String> args) {
  if (args.isEmpty) {
    debugPrint("No args provided."); // Send Error event
    return;
  }

  debugPrint("Native args $args");

  String jsonInput = args[0]; // Read JSON from command-line args
  try {
    Config config = Config.fromJson(jsonInput);
    runApp(const MyApp());
    _initializeAmwalSdk(config);
  } catch (e) {
    debugPrint("Error parsing JSON: $e"); // Send Error event
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Container(
        color: primaryColor, // Set the primary color here
        child: SafeArea(
          child: MaterialApp(
              navigatorObservers: [
                RootNavigatorObserver(),
                AmwalSdkNavigator.amwalNavigatorObserver
              ],
              theme: ThemeData(
                  useMaterial3: false,
                  primarySwatch: Colors.blue,
                  scaffoldBackgroundColor: primaryColor),
              home: const SizedBox.shrink() // No UI,
              ),
        ),
      ),
    );
  }
}

Future<void> _initializeAmwalSdk(Config config) async {
  await AmwalPaySdk.instance.initSdk(
    settings: AmwalSdkSettings(
      environment: EnvironmentExtension.fromString(config.environment),
      sessionToken: config.sessionToken,
      currency: config.currency,
      amount: config.amount,
      transactionId: const Uuid().v1(),
      merchantId: config.merchantId,
      terminalId: config.terminalId,
      locale: Locale(config.locale),
      isMocked: false,
      transactionType: config.transactionType == 'nfc'
          ? TransactionType.nfc
          : TransactionType.cardWallet,
      customerCallback: _customerCallback,
      customerId: config.customerId,
      onResponse: _onResponse,
    ),
  );
}

// Define the customerCallback function
void _customerCallback(String? data) {
  debugPrint("Customer Callback: $data");
  platform.invokeMethod<int>('onCustomerId', {"customerId": data});
  SystemNavigator.pop(animated: false);
}

// Define the onResponse function
void _onResponse(String? response) {
  print("SDK Response: $response");
  platform.invokeMethod<int>('onResponse', {"response": response});
  if (response == null) {
    SystemNavigator.pop(animated: false);
  }
}
