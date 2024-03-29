import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_status_dialog.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/localization/app_localizations.dart';
import 'package:amwal_pay_sdk/localization/app_localizations_setup.dart';
import 'package:flutter/material.dart';

class ReceiptHandler {
  const ReceiptHandler._();
  static ReceiptHandler get instance => const ReceiptHandler._();

  Future<void> showWalletReceipt({
    required BuildContext context,
    required TransactionDetailsSettings settings,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => TransactionStatusDialog(
          settings: settings.copyWith(
            onClose: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> showCardReceipt({
    required BuildContext context,
    required TransactionDetailsSettings settings,
  }) async {
    await Navigator.of(context).push(DialogRoute(
      context: context,
      builder: (_) {
        return TransactionStatusDialog(
          settings: settings.copyWith(
            onClose: () {
              Navigator.pop(_);
              Navigator.pop(_);
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
            },
          ),
        );
      },
    ));
  }

  Future<void> showHistoryReceipt({
    required BuildContext context,
    required TransactionDetailsSettings settings,
  }) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator!.push(DialogRoute(
      context: context,
      builder: (_) {
        return TransactionStatusDialog(
          settings: settings,
        );
      },
    ));
  }
}
