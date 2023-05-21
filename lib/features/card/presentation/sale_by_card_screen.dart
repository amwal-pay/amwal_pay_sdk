import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/merchant_store/merchant_store.dart';
import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_main_button.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_widget.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SaleByCardScreen extends StatefulApiView<SaleByCardManualCubit> {
  final bool is3DS;
  String? transactionId;

  SaleByCardScreen({
    Key? key,
    this.transactionId,
    required this.is3DS,
  }) : super(key: key);

  @override
  State<SaleByCardScreen> createState() => _SaleByCardScreenState();
}

class _SaleByCardScreenState extends State<SaleByCardScreen> {
  String? terminal;
  late List<String> _terminals;
  late int merchantId;
  late String merchantName;

  bool _validateInputs() => terminal != null;

  @override
  void initState() {
    super.initState();
    final merchantStore = MerchantStore.instance;
    merchantId = int.parse(merchantStore.getMerchantId());
    _terminals = merchantStore.getTerminal();
    merchantName = merchantStore.getMerchantName() ?? '';
    if (_terminals.length == 1) {
      terminal = _terminals.single;
    }
  }

  @override
  Widget build(BuildContext context) {
    final amountCurrencyWidgetCubit =
        CardInjector.instance.get<AmountCurrencyWidgetCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightGeryColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: InkWell(
          onTap: AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: Text(
          'sale_by_card_label'.translate(context),
          key: const Key('byCardTitle'),
          style: const TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 30,
        ),
        child: Column(
          children: [
            AmountCurrencyWidget(cubit: amountCurrencyWidgetCubit),
            if (_terminals.length != 1)
              DropDownListWidget<String>(
                name: merchantName,
                hintText: 'choose-terminal'.translate(context),
                cubit: DropDownListCubit(
                  initialValue: terminal,
                ),
                nameMapper: (item) => item!,
                onDone: () => setState(() {}),
                onSelected: (item) => terminal = item,
                dropDownListItems: _terminals,
              ),
            const SizedBox(height: 60),
            AppMainButton(
              key: const Key('manualEntry'),
              buttonIcon: AppAssets.keyBadIcon,
              buttonText: 'manual_entry_label'.translate(context),
              onClicked: () async {
                if (amountCurrencyWidgetCubit.validateAmountInput() &&
                    _validateInputs()) {
                  final paymentArguments = PaymentArguments(
                    amount: amountCurrencyWidgetCubit.amountValue,
                    terminalId: terminal!,
                    currencyData: amountCurrencyWidgetCubit.currencyData,
                    is3DS: widget.is3DS,
                    merchantId: merchantId,
                    transactionId: widget.transactionId,
                  );
                  await AmwalSdkNavigator.instance.toCardOptionScreen(
                    RouteSettings(arguments: paymentArguments),
                    context,
                  );
                } else if (_terminals.length != 1) {
                  final snackBar = SnackBar(
                    content: Text('choose-terminal'.translate(context)),
                    backgroundColor: redColor,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Expanded(
              child: SizedBox(),
            ),
            const AcceptedPaymentMethodsWidget(),
          ],
        ),
      ),
    );
  }
}
