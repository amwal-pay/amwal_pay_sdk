import 'dart:math';

import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/sale_card_feature_common_widgets.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_contact_less_cubit.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:debit_credit_card_widget/debit_credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'dart:convert';

import '../data/models/response/CardInfo.dart';

const MethodChannel javaChannel = MethodChannel('com_amwalpay_sdk');

class SaleByCardContactLessScreen
    extends StatefulApiView<SaleByCardContactLessCubit> {
  final String amount;
  final int currencyId;
  final String currency;
  final String terminalId;
  final int merchantId;
  final bool showAppBar;
  final String? transactionId;
  final String Function(String)? translator;
  final Locale locale;
  final OnPayCallback? onPay;

  const SaleByCardContactLessScreen({
    super.key,
    required this.amount,
    required this.currencyId,
    required this.currency,
    required this.terminalId,
    required this.merchantId,
    this.showAppBar = true,
    this.transactionId,
    this.translator,
    required this.locale,
    required this.onPay,
  });

  @override
  State<SaleByCardContactLessScreen> createState() =>
      _SaleByCardContactLessScreen();
}

class _SaleByCardContactLessScreen extends State<SaleByCardContactLessScreen> {
  int setupStatusIndex = 0;
  String setupMessage = "Initializing SDK..";
  CardInfo? cardInfo;
  bool setupComplete = false;
  int flowIndex = 0;
  bool isScanning = false;

  String scanResult = "";

  Future<void> checkNFCStatus() async {
    try {
      setupStatusIndex = await javaChannel.invokeMethod('init');
      if (setupStatusIndex != 2) {
        setState(() {
          setupMessage = setupStatusIndex == 0
              ? "NFC Unavailable"
              : "Turn on NFC and restart the app";
          setupComplete = true;
        });
        return;
      }

      setState(() {
        setupMessage = "Start Scan";
      });
      initCardScanListener();
      flowIndex++;
      setupComplete = true;
    } catch (e) {
      setState(() {
        print(e.toString());
        setupStatusIndex = 0;
        setupMessage = "NFC Unavailable";
        setupComplete = true;
      });
    }
  }

  Future<void> initCardScanListener() async {
    try {
      final scanOp = json.decode(await javaChannel.invokeMethod("listen"));
      if (scanOp['success']) {
        setState(() {
          setState(() {
            scanResult = scanOp['cardData'];
            cardInfo = CardInfo.fromJson(scanOp);
            flowIndex++;
            isScanning = false;
            setupMessage = "Scanning completed";
          });
        });
        return;
      }
      throw PlatformException(code: '01', stacktrace: scanOp['error']);
    } catch (e) {
      if (context.mounted) {
        setState(() {
          flowIndex--;
          isScanning = false;
        });
        showSnackMessage(
          context,
          e.toString(),
          ["OK", () {}],
        );
      }
    }
  }

  Future<void> forceTerminateNFC() async {
    // ignore: empty_catches
    try {
      await javaChannel.invokeMethod('terminate');
    } on PlatformException {}
  }

  @override
  void initState() {
    super.initState();
    checkNFCStatus();
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = PaymentArguments(
      terminalId: widget.terminalId,
      amount: widget.amount,
      merchantId: widget.merchantId,
      transactionId: widget.transactionId,
      currencyData: CurrencyData(
        idN: widget.currencyId,
        name: widget.currency,
        id: widget.currencyId.toString(),
      ),
    );
    return Scaffold(
      backgroundColor: lightGeryColor,
      appBar: !widget.showAppBar
          ? null
          : AppBar(
              backgroundColor: whiteColor,
              leading: InkWell(
                onTap: Navigator.of(context).pop,
                child: const Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
              title: Text(
                'card_details_label'.translate(
                  context,
                  globalTranslator: widget.translator,
                ),
                key: const Key('cardDetails'),
                style: const TextStyle(
                  color: blackColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: 18,
            ),
            child: SaleCardFeatureCommonWidgets.merchantAndAmountInfo(
              context,
              args,
              translator: widget.translator,
            ),
          ),
          const SizedBox(height: 16),
          (cardInfo != null)
              ?  Expanded(
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DebitCreditCardWidget(
                        cardHolderName: ("${cardInfo!.holderFirstname ?? ""} ${cardInfo!.holderLastname ?? ""}"),
                        cardNumber: cardInfo!.cardNumber.toString(),
                        cardExpiry: cardInfo!.cardExpiry.toString(),
                        cardType: CardType.credit,
                      ),
                    ),
                  ),
              )
              : Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: SvgPicture.asset(
                            AppAssets.contactLessImageIcon,
                            package: 'amwal_pay_sdk',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'tap_the_card_or_phone_msg'.translate(
                            context,
                            globalTranslator: widget.translator,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          setupMessage,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          const AcceptedPaymentMethodsWidget(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

Future<void> showSnackMessage(
    BuildContext context, String message, dynamic action) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: const Color(0xFF2d3134),
    closeIconColor: Colors.white,
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(10),
    action: action == null
        ? null
        : SnackBarAction(
            textColor: Colors.blue,
            label: action[0],
            onPressed: () => action[1](),
          ),
  ));
}
