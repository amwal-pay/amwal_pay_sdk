import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/presentation/amwal_pay_screen.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';

import 'package:flutter/material.dart';

import 'amwal_sdk_settings/amwal_sdk_settings.dart';
import 'localization/app_localizations_setup.dart';

void main(List<String> args) {
 final settings = AmwalSdkSettings.fromArgs(args);
  runApp( MyApp(settings: settings,));
}

class MyApp extends StatefulWidget {
  final AmwalSdkSettings settings;
  const MyApp({super.key, required this.settings});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInitialized = false;
  late AmwalSdkSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings.copyWith(context: context);
    _initSdk();
  }

  Future<void> _initSdk() async {
    await AmwalPaySdk.instance.initSdk(
      settings: _settings,
    );
    setState(() => isInitialized = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amwal pay Demo',
      localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      navigatorObservers: [
        AmwalSdkNavigator.amwalNavigatorObserver,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isInitialized
          ? AmwalPayScreen(
              arguments: AmwalSdkArguments(
                amount: _settings.amount,
                currency: _settings.currency,
                currencyId: 512,
                terminalId: _settings.terminalId,
                locale: _settings.locale,
                is3DS: _settings.is3DS,
              ),
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
