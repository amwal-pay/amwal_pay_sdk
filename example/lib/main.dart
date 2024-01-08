import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:example/text_form.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
        useMaterial3: false,
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
  late TextEditingController _currencyController;
  late TextEditingController _amountController;
  late TextEditingController _merchantIdController;
  late TextEditingController _terminalController;
  late TextEditingController _secureHashController;

  @override
  void initState() {
    super.initState();

    /// card terminal => 6942344
    /// wallet terminal => 6834180
    _terminalController = TextEditingController(text: '6834180');
    _merchantIdController = TextEditingController(text: '1369217');
    _secureHashController = TextEditingController(
      text: '9FFA1F36D6E8A136482DF921E856709226DE5A974DB2673F84DB79DA788F7E19',
    );
    _amountController = TextEditingController(text: '50');
    _currencyController = TextEditingController(text: 'OMR');
  }

  @override
  void dispose() {
    _terminalController.dispose();
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        // TextForm(
                        //   title: "Transaction Ref No",
                        //   controller: _transactionRefNoController,
                        // ),
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
                      currency: _currencyController.text,
                      amount: _amountController.text,
                      transactionId: const Uuid().v1(),
                      merchantId: _merchantIdController.text,
                      secureHashValue: _secureHashController.text,
                      terminalId: _terminalController.text,
                      isMocked: false,
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
