import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/ui/count_down_dialog/count_down_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_status_dialog.dart';

import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:flutter/material.dart';

mixin SaleByWalletActionsMixin on ApiView<SaleByWalletCubit> {
  Future<void> _onCountDownComplete(
    BuildContext context,
    WalletPayData? walletPayData,
    String Function(String)? globalTranslator,
  ) async {
    await showTransactionDialog(
      context,
      walletPayData,
      globalTranslator,
    );
  }

  Future<void> showTransactionDialog(
    BuildContext context,
    WalletPayData? walletPayData,
    String Function(String)? globalTranslator,
  ) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => TransactionStatusDialog(
          globalTranslator: globalTranslator,
          details: {
            'idN': walletPayData?.idN,
            'terminal_id': walletPayData?.terminalId,
            'amount': walletPayData?.amount,
            'merchant_id': walletPayData?.merchantId,
            'from': walletPayData?.from,
          },
          transactionStatus: TransactionStatus.success,
          onClose: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
          },
        ),
      ),
    );
  }

  Future<void> showCountingDialog(
    BuildContext context,
    WalletPayData? walletPayData,
    String Function(String)? globalTranslator,
  ) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => CountDownDialog(
          globalTranslator: globalTranslator,
          onComplete: () async {
            Navigator.of(context).pop();
            await _onCountDownComplete(
              context,
              walletPayData,
              globalTranslator,
            );
          },
        ),
      ),
    );
  }
}
