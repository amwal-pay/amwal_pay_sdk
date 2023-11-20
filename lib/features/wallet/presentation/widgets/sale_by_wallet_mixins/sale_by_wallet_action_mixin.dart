import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/ui/count_down_dialog/count_down_dialog.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/receipt/receipt_handler.dart';
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
    String Function(String)? globalTranslator,
    required String transactionId,
    required int merchantId,
    required void Function() resetWallet,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => CountDownDialog(
          globalTranslator: globalTranslator,
          onComplete: () async {
            final getTransactionUseCase =
                WalletInjector.instance.get<GetOneTransactionByIdUseCase>();
            final oneTransactionResponse = await getTransactionUseCase.invoke({
              'transactionId': transactionId,
              'merchantId': merchantId,
            });
            final oneTransaction = oneTransactionResponse.mapOrNull(
                success: (value) => value.data.data);
            if (oneTransaction == null) return;
            if (!context.mounted) return;
            Navigator.pop(context);
            await ReceiptHandler.instance.showHistoryReceipt(
              context: context,
              settings: _generateTransactionSettings(
                oneTransaction,
                context,
              ).copyWith(
                onClose: () {
                  resetWallet();
                  AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> showCountingDialog(
    BuildContext context,
    String Function(String)? globalTranslator,
    String currency,
    String transactionId,
    int merchantId,
    void Function() resetWallet,
  ) async {
    await countingDialog(
      context: context,
      globalTranslator: globalTranslator,
      transactionId: transactionId,
      merchantId: merchantId,
      resetWallet: resetWallet,
    );
  }
}
