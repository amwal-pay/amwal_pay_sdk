
import 'package:amwal_pay_sdk/features/card/presentation/sale_by_card_manual_screen.dart';
import 'package:amwal_pay_sdk/features/wallet/presentation/screen/sale_by_wallet_paying_options.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

import 'color/colors.dart';

class AmwalPayScreen extends StatelessWidget {
  final AmwalSdkArguments arguments;
  const AmwalPayScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,

          title: const Text('Amwal Pay'),
          bottom: TabBar(tabs: [
            Tab(
              text: 'wallet_label'.translate(context),
            ),
            Tab(
              text: 'card'.translate(context),
            ),
          ],),
        ),
        body: TabBarView(
          children: [
            SaleByWalletPayingOptions(
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              showAppBar: false,
              translator: (txt) => txt.translate(context),
            ),
            SaleByCardManualScreen(
              amount: arguments.amount,
              terminalId: arguments.terminalId,
              currency: arguments.currency,
              currencyId: arguments.currencyId,
              showAppBar: false,
              translator: (txt) => txt.translate(context),
            ),
          ],
        ),
      ),
    );
  }
}
