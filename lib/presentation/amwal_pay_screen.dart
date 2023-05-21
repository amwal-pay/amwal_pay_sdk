import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_manual_screen.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_paying_options.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
            Tab(
              text: 'wallet_label'.translate(context),
            ),
            Tab(
              text: 'card'.translate(context),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            SaleByWalletPayingOptions(
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              merchantId: arguments.merchantId,
              transactionId: arguments.transactionId,

              showAppBar: false,
              translator: (txt) => txt.translate(context),
            ),
            SaleByCardManualScreen(
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              merchantId: arguments.merchantId,
              transactionId: arguments.transactionId,
              is3DS: arguments.is3DS,
              showAppBar: false,
              translator: (txt) => txt.translate(context),
            ),
          ],
        ),
      ),
    );
  }
}
