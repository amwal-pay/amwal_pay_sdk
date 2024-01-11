import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/tablayout/tab_layout_cubit.dart';
import 'package:amwal_pay_sdk/core/tablayout/tab_layout_generic_widget.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/sale_card_feature_common_widgets.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_pay_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/alias_pay_widget.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/phone_pay_widget.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/sale_action_buttons.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/widgets/scan_qr_to_pay.dart';
import 'package:amwal_pay_sdk/features/wallet/state/sale_by_wallet_state.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaleByWalletPayingOptions extends ApiView<SaleByWalletPayCubit> {
  final String amount;
  final String terminalId;
  final int merchantId;
  final String currency;
  final int currencyId;
  final bool showAppBar;
  final String? transactionId;
  final OnPayCallback onPay;
  final OnPayCallback onCountComplete;
  final GetTransactionFunction getTransactionFunction;
  final String Function(String)? translator;
  final int countDownInSeconds;

  const SaleByWalletPayingOptions({
    Key? key,
    required this.onPay,
    required this.getTransactionFunction,
    required this.onCountComplete,
    required this.amount,
    required this.terminalId,
    required this.currency,
    required this.currencyId,
    required this.merchantId,
    required this.countDownInSeconds,
    this.transactionId,
    this.showAppBar = true,
    this.translator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentArgument = PaymentArguments(
      amount: amount,
      terminalId: terminalId,
      merchantId: merchantId,
      transactionId: transactionId,
      currencyData: CurrencyData(
        idN: currencyId,
        id: currency.toString(),
        name: currency,
      ),
    );
    final saleByWalletCubit = WalletInjector.instance.get<SaleByWalletCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightGeryColor,
      appBar: !showAppBar
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
                'sale_by_wallet_label'.translate(
                  context,
                  globalTranslator: translator,
                ),
                style: const TextStyle(
                  color: blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      body: Container(
        color: whiteColor,
        child: Column(
          children: [
            const SizedBox(height: 8),
            TabLayoutGenericWidget(
              tabLayoutCubit: TabLayoutCubit(saleByWalletCubit.state.page),
              tabsValues: [
                'mobile_tab'.translate(
                  context,
                  globalTranslator: translator,
                ),
                'alis_tab'.translate(
                  context,
                  globalTranslator: translator,
                ),
                'qr_tab'.translate(
                  context,
                  globalTranslator: translator,
                ),
              ],
              onTabSelected: saleByWalletCubit.updatePage,
            ),
            Expanded(
              child: Container(
                color: lightGeryColor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SaleCardFeatureCommonWidgets.merchantAndAmountInfo(
                        context,
                        paymentArgument,
                        translator: translator,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocBuilder<SaleByWalletCubit, SaleByWalletState>(
                      bloc: saleByWalletCubit,
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _saleByWalletOptions(
                            state.page,
                            paymentArgument,
                            translator,
                            onPay,
                            getTransactionFunction,
                          ),
                        );
                      },
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    SaleActionButtons(
                      onPay: onPay,
                      onCountComplete: onCountComplete,
                      paymentArguments: paymentArgument,
                      globalTranslator: translator,
                      countDownInSeconds: countDownInSeconds,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<SaleByWalletCubit, SaleByWalletState>(
                      bloc: saleByWalletCubit,
                      builder: (context, state) {
                        if (state.page != 2) {
                          return const AcceptedPaymentMethodsWidget(
                            showMaster: false,
                            showVisa: false,
                            showExpress: false,
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _saleByWalletOptions(
  int pageNum,
  PaymentArguments paymentArguments,
  String Function(String)? globalTranslator,
  OnPayCallback onPay,
  GetTransactionFunction getTransactionFunction,
) {
  if (pageNum == 0) {
    return PhonePayWidget(
      globalTranslator: globalTranslator,
    );
  } else if (pageNum == 1) {
    return AliasPayWidget(
      globalTranslator: globalTranslator,
    );
  } else if (pageNum == 2) {
    return ScanQrToPayWidget(
      getTransactionFunction: getTransactionFunction,
      paymentArguments: paymentArguments,
      globalTranslator: globalTranslator,
      onPay: onPay,
    );
  } else {
    return const SizedBox();
  }
}
