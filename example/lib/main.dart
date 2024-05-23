import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_settings.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:example/currency_model.dart';
import 'package:example/drop_down_form.dart';
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        title: 'Amwal pay Demo',
        navigatorObservers: [
          AmwalSdkNavigator.amwalNavigatorObserver,
        ],
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        home: const DemoScreen(),
      ),
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

  late GlobalKey<FormState> _formKey;
  late String altBaseurl;
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    /// card terminal => 6942344
    /// wallet terminal => 6834180
    _terminalController = TextEditingController(text: '12895');
    _merchantIdController = TextEditingController(text: '17023');
    _secureHashController = TextEditingController(
      text: '15FBFB9555CCAF369E01C3232E836B57B0BAF7C66DFBC1CADFC9BA3DC31E2F20',
    );
    _amountController = TextEditingController(text: '50');
    _currencyController = TextEditingController(text: 'OMR');

    altBaseurl = NetworkConstants.baseUrlSdk;
    dropdownValue = _getDropdownValueFromAltBaseUrl(altBaseurl);
  }

  String _getDropdownValueFromAltBaseUrl(String altBaseUrl) {
    if (altBaseUrl == NetworkConstants.SITUrlSdk) {
      return 'SIT';
    } else if (altBaseUrl == NetworkConstants.UATUrlSdk) {
      return 'UAT';
    } else if (altBaseUrl == NetworkConstants.PRODUrlSdk) {
      return 'PROD';
    } else {
      return 'None';
    }
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
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TextForm(
                          title: "Merchant Id",
                          controller: _merchantIdController,
                          isNumeric: true,
                          maxLength: 10,
                        ),
                        TextForm(
                          title: "Terminal Id",
                          controller: _terminalController,
                          isNumeric: true,
                          maxLength: 10,
                        ),
                        TextForm(
                          title: "Amount",
                          controller: _amountController,
                          isNumeric: true,
                          maxAmount: 1000000,
                          maxLength: 30,
                          validator: (value) {
                            if (double.parse(value!) < 1.0) {
                              return 'Invalid Amount';
                            } else {
                              return null;
                            }
                          },
                        ),
                        DropdownForm<CurrencyModel>(
                          title: 'Currency',
                          options: const [
                            CurrencyModel(name: 'OMR', id: '512'),
                          ],
                          valueMapper: (currency) => currency.id,
                          nameMapper: (currency) => currency.name,
                          initialValue:
                              const CurrencyModel(name: 'OMR', id: '512'),
                          onChanged: (currencyId) {
                            _currencyController.text = currencyId ?? '';
                          },
                        ),
                        TextForm(
                          title: "Secret Key",
                          controller: _secureHashController,
                        ),
                        const SizedBox(height: 8),
                        const Text("Select Environment"),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey, // Specify the border color
                              width: 2.0, // Specify the border width
                            ),
                            borderRadius: BorderRadius.circular(
                                10), // Optional: Add rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  switch (dropdownValue) {
                                    case 'SIT':
                                      altBaseurl = NetworkConstants.SITUrlSdk;
                                      break;
                                    case 'UAT':
                                      altBaseurl = NetworkConstants.UATUrlSdk;
                                      break;
                                    case 'PROD':
                                      altBaseurl = NetworkConstants.PRODUrlSdk;
                                      break;
                                    default:
                                      altBaseurl = '';
                                      break;
                                  }

                                  NetworkConstants.baseUrlSdk = altBaseurl;
                                });
                              },
                              items: <String>[
                                'None',
                                'SIT',
                                'UAT',
                                'PROD'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = _formKey.currentState!.validate();
                  if (!valid) return;
                  await AmwalPaySdk.instance.initSdk(
                    settings: AmwalSdkSettings(
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
