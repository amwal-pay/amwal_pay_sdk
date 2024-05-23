import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_manual_screen.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_paying_options.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

import '../core/merchant_store/merchant_store.dart';
import 'color/colors.dart';

class AmwalPayScreen extends StatelessWidget {
  final AmwalSdkArguments arguments;
  const AmwalPayScreen({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          leading: InkWell(
            onTap: AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          title: const Text('Amwal Pay'),
          bottom: TabBar(tabs: [
            if(MerchantStore.instance.getMerchantData()?.terminalData.canCardTransaction ?? false)
            Tab(
              text: 'card'.translate(context),
            ),
            if(MerchantStore.instance.getMerchantData()?.terminalData.canWalletTransaction ?? false)
              Tab(
              text: 'wallet_label'.translate(context),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            if(MerchantStore.instance.getMerchantData()?.terminalData.canCardTransaction ?? false)
            SaleByCardManualScreen(
              onPay: arguments.onPay,
              locale: arguments.locale,
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              merchantId: arguments.merchantId,
              transactionId: arguments.transactionId,
              showAppBar: false,
              translator: (txt) => txt.translate(context),
            ),
            if(MerchantStore.instance.getMerchantData()?.terminalData.canWalletTransaction ?? false)
            SaleByWalletPayingOptions(
              getTransactionFunction: arguments.getTransactionFunction,
              onPay: arguments.onPay,
              onCountComplete: arguments.onCountComplete ?? (_, [__]) {},
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              merchantId: arguments.merchantId,
              transactionId: arguments.transactionId,
              showAppBar: false,
              translator: (txt) => txt.translate(context),
              countDownInSeconds: 30,
            ),
          ],
        ),
      ),
    );
  }
}
