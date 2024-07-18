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

import '../../../core/loader_mixin.dart';
import '../../transaction/domain/use_case/get_transaction_by_Id.dart';
import '../cubit/card_transaction_manager.dart';
import '../data/models/response/CardInfo.dart';
import '../dependency/injector.dart';

class SaleByCardContactLessScreen
    extends StatefulApiView<SaleByCardContactLessCubit> with LoaderMixin {
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
  Future<void> checkNFCStatus() async {
    try {
      widget.cubit.setupStatusIndex = await javaChannel.invokeMethod('init');
      if (widget.cubit.setupStatusIndex != 2) {
        widget.cubit.setupMessage = widget.cubit.setupStatusIndex == 0
            ? "nfc_unavailable".translate(
                context,
                globalTranslator: widget.translator,
              )
            : "nfc_unavailable_massage".translate(
                context,
                globalTranslator: widget.translator,
              );

        return;
      }

      widget.cubit.setupMessage = "start_scan".translate(
        context,
        globalTranslator: widget.translator,
      );
    } catch (e) {
      widget.cubit.setupStatusIndex = 0;
      widget.cubit.setupMessage = "nfc_unavailable".translate(
        context,
        globalTranslator: widget.translator,
      );
    }

    widget.cubit.arg = PaymentArguments(
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
    initCardScanListener();
  }

  initCardScanListener() async {
    try {
      final scanOp = json.decode(await javaChannel.invokeMethod("listen"));
      if (scanOp['success']) {
        if (widget.cubit.cardInfo != null) {
          return;
        }
        widget.cubit.cardInfo = CardInfo.fromJson(scanOp);
        widget.cubit.fillCardData(widget.cubit.cardInfo!);
        widget.cubit.setupMessage = "Scanning completed".translate(
          context,
          globalTranslator: widget.translator,
        );

        setState(() {});
        CardTransactionManager.instance.onPurchaseWith3DS(
          cubit: widget.cubit,
          args: widget.cubit.arg!,
          context: context,
          getOneTransactionByIdUseCase:
              CardInjector.instance.get<GetOneTransactionByIdUseCase>(),
          dismissLoader: widget.dismissDialog,
          onPay: widget.onPay,
        );
        return;
      }
      throw PlatformException(code: '01', stacktrace: scanOp['error']);
    } catch (e) {
      if (context.mounted) {
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
    super.dispose();
    forceTerminateNFC();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.cubit.arg!,
              translator: widget.translator,
            ),
          ),
          const SizedBox(height: 16),
          (widget.cubit.cardInfo != null)
              ? Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DebitCreditCardWidget(
                        cardHolderName:
                            ("${widget.cubit.cardInfo!.holderFirstname ?? ""} ${widget.cubit.cardInfo!.holderLastname ?? ""}"),
                        cardNumber:
                            widget.cubit.cardInfo!.cardNumber.toString(),
                        cardExpiry:
                            widget.cubit.cardInfo!.cardExpiry.toString(),
                        cardBrand: widget.cubit
                            .getCardBrand(widget.cubit.cardInfo!.cardNumber!),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              widget.cubit.setupMessage,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
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
