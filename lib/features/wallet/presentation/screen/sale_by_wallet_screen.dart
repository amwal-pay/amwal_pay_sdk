import 'package:amwal_pay_sdk/core/merchant_store/merchant_store.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_widget.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';

import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:flutter/material.dart';

class SaleByWalletScreen extends StatefulWidget {
  const SaleByWalletScreen({Key? key}) : super(key: key);

  @override
  State<SaleByWalletScreen> createState() => _SaleByWalletScreenState();
}

class _SaleByWalletScreenState extends State<SaleByWalletScreen> {
  late MerchantStore merchantStore;
  late List<String> terminals;
  String? _terminal;
  bool _validateInputs() => _terminal != null;
  late AmountCurrencyWidgetCubit amountCubit;

  @override
  void initState() {
    super.initState();
    amountCubit = AmountCurrencyWidgetCubit();
    merchantStore = MerchantStore.instance;
    terminals = merchantStore.getTerminal();
    if (terminals.length == 1) {
      _terminal = terminals.single;
    }
  }

  Future<void> _navigateToSaleByWalletOptions(
    PaymentArguments arguments,
  ) async {
    final saleByWalletCubit = WalletInjector.instance.get<SaleByWalletCubit>();
    saleByWalletCubit.init();
    await AmwalSdkNavigator.instance.toWalletOptionsScreen(
      context,
      RouteSettings(arguments: arguments),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: lightGeryColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        title: Text(
          'sale_by_wallet_label'.translate(context),
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
            AmountCurrencyWidget(cubit: amountCubit),
            if (terminals.length != 1)
              DropDownListWidget<String>(
                hintText: 'terminal'.translate(context),
                cubit: DropDownListCubit(
                  initialValue: _terminal,
                ),
                nameMapper: (item) => item!,
                onDone: () => setState(() {}),
                onSelected: (item) => _terminal = item,
                onCancel: () => _terminal = null,
                dropDownListItems: terminals,
              ),
            const SizedBox(
              height: 60,
            ),
            SizedBox(
              width: size.width,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    side: const BorderSide(
                      color: lightGreyColor,
                    ),
                  ),
                ),
                onPressed: () async {
                  if (amountCubit.validateAmountInput() && _validateInputs()) {
                    final args = PaymentArguments(
                      amount: amountCubit.amountValue,
                      terminalId: _terminal ?? '',
                      currencyData: amountCubit.currencyData,
                    );
                    await _navigateToSaleByWalletOptions(args);
                  } else if (terminals.length != 1) {
                    final snackBar = SnackBar(
                      content:
                          Text('select_terminal_id_label'.translate(context)),
                      backgroundColor: redColor,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'btn_next'.translate(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
