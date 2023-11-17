import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/ui/count_down_dialog/count_down_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/features/transaction/util.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';

typedef OnWalletNotificationReceived = void Function(
    void Function(TransactionDetailsSettings) listener);

mixin SaleByWalletActionsMixin on ApiView<SaleByWalletCubit> {
  TransactionDetailsSettings _generateTransactionSettings(
    OneTransaction oneTransaction,
    BuildContext context,
  ) {
    return TransactionDetailsSettings(
      amount: oneTransaction.amount,
      transactionDisplayName: oneTransaction.transactionTypeDisplayName,
      isSuccess: oneTransaction.responseCodeName == 'Approved',
      transactionStatus: oneTransaction.responseCodeName == 'Approved'
          ? TransactionStatus.success
          : TransactionStatus.failed,
      transactionType: oneTransaction.transactionType,
      isTransactionDetails: false,
      globalTranslator: (string) => string.translate(context),
      details: {
        'merchant_name_label': oneTransaction.merchantName,
        'ref_no': oneTransaction.idN,
        'merchant_id': oneTransaction.merchantId,
        'terminal_id': oneTransaction.terminalId,
        'date_time': oneTransaction.transactionTime.formatDate(context),
        'amount': oneTransaction.transactionAmount(context),
      },
    );
  }

  Future<void> countingDialog({
    required BuildContext context,
    required OnPayCallback onCountingComplete,
    String Function(String)? globalTranslator,
    required String transactionId,
    required int merchantId,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => CountDownDialog(
          globalTranslator: globalTranslator,
          onComplete: () async {
            if (NetworkConstants.isSdkInApp) {
              final getTransactionUseCase =
                  WalletInjector.instance.get<GetOneTransactionByIdUseCase>();
              final oneTransactionResponse =
                  await getTransactionUseCase.invoke({
                'transactionId': transactionId,
                'merchantId': merchantId,
              });
              final oneTransaction = oneTransactionResponse.mapOrNull(
                  success: (value) => value.data.data);
              if (oneTransaction == null) return;
              if (!context.mounted) return;
              await ReceiptHandler.instance.showHistoryReceipt(
                context: context,
                settings: _generateTransactionSettings(
                  oneTransaction,
                  context,
                ).copyWith(
                  onClose: () {
                    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                  },
                ),
              );
            } else {
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
            }
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
    String transactionId,
    int merchantId,
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
      transactionId: transactionId,
      merchantId: merchantId,
    );
  }
}
