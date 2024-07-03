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
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'dart:convert';
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
  late NfcManager _nfcManager;
  bool _isNfcAvailable = false;

  @override
  void initState() {
    super.initState();
    _nfcManager = NfcManager.instance;
    _nfcManager.isAvailable().then(
      (value) {
        setState(
          () => _isNfcAvailable = value,
        );
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            var nfca = NfcA.from(tag);

            var panString = utf8.decoder.convert(nfca!.identifier.toList());

            print('panString: $panString');

          },
        );
      },
    );
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
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: SvgPicture.asset(
                    AppAssets.contactLessImageIcon,
                    package: 'amwal_pay_sdk',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'tap_the_card_or_phone_msg'.translate(
                    context,
                    globalTranslator: widget.translator,
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const AcceptedPaymentMethodsWidget(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
