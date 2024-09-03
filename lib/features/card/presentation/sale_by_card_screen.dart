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
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SaleByCardScreen extends StatefulApiView<SaleByCardManualCubit> {
  final String? transactionId;
  final Locale locale;
  final OnPayCallback onPay;

  const SaleByCardScreen({
    Key? key,
    this.transactionId,
    required this.locale,
    required this.onPay,
  }) : super(key: key);

  @override
  State<SaleByCardScreen> createState() => _SaleByCardScreenState();
}

class _SaleByCardScreenState extends State<SaleByCardScreen> {
  String? terminal;
  late List<String> _terminals;
  late int merchantId;
  late String merchantName;
  late AmountCurrencyWidgetCubit _amountCurrencyWidgetCubit;

  final _hideKeyboard = FocusManager.instance.primaryFocus?.unfocus;

  @override
  void initState() {
    super.initState();
    _amountCurrencyWidgetCubit =
        CardInjector.instance.get<AmountCurrencyWidgetCubit>();
    final merchantStore = MerchantStore.instance;
    merchantId = int.parse(merchantStore.getMerchantId());
    _terminals = merchantStore.getTerminal();
    merchantName = merchantStore.getMerchantName() ?? '';
    terminal = _terminals.first;
  }

  @override
  Widget build(BuildContext context) {
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
            AmountCurrencyWidget(cubit: _amountCurrencyWidgetCubit),
            if (_terminals.length != 1)
              DropDownListWidget<String>(
                name: "Web Terminal",
                hintText: 'choose-terminal'.translate(context),
                cubit: DropDownListCubit(
                  initialValue:
                      terminal == null ? terminal : 'Web Terminal - $terminal',
                ),
                nameMapper: (item) => item!,
                onDone: () => setState(() {}),
                onSelected: (item) => terminal = item,
                onCancel: () => terminal = null,
                dropDownListItems: _terminals,
              ),
            const SizedBox(height: 60),
            AppMainButton(
              key: const Key('manualEntry'),
              buttonIcon: AppAssets.keyBadIcon,
              buttonText: 'manual_entry_label'.translate(context),
              onClicked: () async {
                _hideKeyboard?.call();
                final validation = _amountCurrencyWidgetCubit.validateFields(
                  context: context,
                  terminal: terminal,
                );
                if (validation != null) {
                  _amountCurrencyWidgetCubit.showErrorSnackBar(
                    context: context,
                    message: validation,
                  );
                  return;
                }
                if (!_amountCurrencyWidgetCubit.formKey.currentState!
                    .validate()) {
                  return;
                }
                final paymentArguments = PaymentArguments(
                  amount: _amountCurrencyWidgetCubit.amountValue,
                  terminalId: terminal!,
                  currencyData: _amountCurrencyWidgetCubit.currencyData,
                  merchantId: merchantId,
                  transactionId: widget.transactionId,
                );
                await AmwalSdkNavigator.instance.toCardOptionScreen(
                  RouteSettings(arguments: paymentArguments),
                  context,
                  widget.locale,
                  widget.onPay,
                );
              },
            ),
            const SizedBox(height: 15),
            // if debug
            if (MerchantStore.instance.getMerchantFlavor() == 'vpos' ||
                kDebugMode)
              AppMainButton(
                key: const Key('contactless'),
                buttonIcon: AppAssets.contactlessIcon,
                buttonText: 'contact_less_label'.translate(context),
                onClicked: () async {
                  _hideKeyboard?.call();
                  final validation = _amountCurrencyWidgetCubit.validateFields(
                    context: context,
                    terminal: terminal,
                  );
                  if (validation != null) {
                    _amountCurrencyWidgetCubit.showErrorSnackBar(
                      context: context,
                      message: validation,
                    );
                    return;
                  }
                  if (!_amountCurrencyWidgetCubit.formKey.currentState!
                      .validate()) {
                    return;
                  }
                  final paymentArguments = PaymentArguments(
                    amount: _amountCurrencyWidgetCubit.amountValue,
                    terminalId: terminal!,
                    currencyData: _amountCurrencyWidgetCubit.currencyData,
                    merchantId: merchantId,
                    transactionId: widget.transactionId,
                  );
                  await AmwalSdkNavigator.instance
                      .toCardContactLessOptionScreen(
                    RouteSettings(arguments: paymentArguments),
                    context,
                    widget.locale,
                    widget.onPay,
                  );
                },
              ),
            const SizedBox(height: 15),
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
