import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:example/text_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amwal pay Demo',
      navigatorObservers: [
        AmwalSdkNavigator.amwalNavigatorObserver,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  late TextEditingController _tokenController;
  late TextEditingController _currencyController;
  late TextEditingController _amountController;
  late TextEditingController _merchantIdController;
  late TextEditingController _transactionRefNoController;
  late TextEditingController _terminalController;
  late TextEditingController _secureHashController;
  bool _is3DS = false;

  @override
  void initState() {
    super.initState();
    _terminalController = TextEditingController(text: '6942344');
    _tokenController = TextEditingController(text: '');
    _transactionRefNoController = TextEditingController(text: '');
    _merchantIdController = TextEditingController(text: '1369217');
    _secureHashController =
        TextEditingController(text: '9FFA1F36D6E8A136482DF921E856709226DE5A974DB2673F84DB79DA788F7E19');
    _amountController = TextEditingController(text: '240');
    _currencyController = TextEditingController(text: 'OMR');
  }

  @override
  void dispose() {
    _terminalController.dispose();
    _tokenController.dispose();
    _transactionRefNoController.dispose();
    _merchantIdController.dispose();
    _secureHashController.dispose();
    _amountController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amwal Pay Demo'),
      ),
      body: SizedBox(
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextForm(
                          title: "Token",
                          controller: _tokenController,
                        ),
                        TextForm(
                          title: "Merchant Id",
                          controller: _merchantIdController,
                        ),
                        TextForm(
                          title: "Terminal Id",
                          controller: _terminalController,
                        ),
                        TextForm(
                          title: "Amount",
                          controller: _amountController,
                        ),
                        TextForm(
                          title: "Currency",
                          controller: _currencyController,
                        ),
                        TextForm(
                          title: "Secure Hash",
                          controller: _secureHashController,
                        ),
                        TextForm(
                          title: "Transaction Ref No",
                          controller: _transactionRefNoController,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AmwalPaySdk.instance.initSdk(
                    settings: AmwalSdkSettings(
                      merchantName: 'Amr Saied',
                      token: _tokenController.text,
                      currency: _currencyController.text,
                      amount: _amountController.text,
                      transactionId: _transactionRefNoController.text,
                      merchantId: _merchantIdController.text,
                      secureHashValue: _secureHashController.text,
                      terminalId: _terminalController.text,
                      isMocked: false,
                      is3DS: _is3DS,
                    ),
                  );
                },
                child: const Text('initiate payment demo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
