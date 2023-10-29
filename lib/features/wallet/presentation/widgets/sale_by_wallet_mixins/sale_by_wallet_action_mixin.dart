import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/ui/count_down_dialog/count_down_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

typedef OnWalletNotificationReceived = void Function(
    void Function(TransactionDetailsSettings) listener);

mixin SaleByWalletActionsMixin on ApiView<SaleByWalletCubit> {
  Future<void> countingDialog({
    required BuildContext context,
    required OnPayCallback onCountingComplete,
    String Function(String)? globalTranslator,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => CountDownDialog(
          globalTranslator: globalTranslator,
          onComplete: () {
            onCountingComplete((settings) async {
              final isDialogOpen = ModalRoute.of(context)!.isCurrent != true;
              if (isDialogOpen && context.mounted) {
                Navigator.of(context).pop();
              }
              if (context.mounted) {
                await ReceiptHandler.instance.showWalletReceipt(
                  context: context,
                  settings: settings,
                );
              }
            });
          },
        ),
      ),
    );
  }

  Future<void> showCountingDialog(
    BuildContext context,
    String Function(String)? globalTranslator,
    OnPayCallback onPay,
    OnPayCallback onCountingComplete,
    String currency,
  ) async {
    onPay((settings) async {
      final isDialogOpen =
          context.mounted && ModalRoute.of(context)!.isCurrent != true;
      if (isDialogOpen) {
        Navigator.of(context).pop();
      }
      if (context.mounted) {
        await ReceiptHandler.instance.showWalletReceipt(
          context: context,
          settings: settings,
        );
      }
    });
    await countingDialog(
      context: context,
      globalTranslator: globalTranslator,
      onCountingComplete: onCountingComplete,
    );
  }
}
