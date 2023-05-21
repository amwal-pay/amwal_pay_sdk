import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_status_dialog.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/wallet/data/models/response/wallet_pay_response.dart';
import 'package:amwal_pay_sdk/localization/app_localizations.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';

class ReceiptHandler {
  const ReceiptHandler._();
  static ReceiptHandler get instance => const ReceiptHandler._();

  Future<void> showWalletReceipt({
    required BuildContext context,
    required WalletPayData walletPayData,
    String Function(String)? globalTranslator,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) => TransactionStatusDialog(
          globalTranslator: globalTranslator,
          details: {
            'idN': walletPayData.idN,
            'terminal_id': walletPayData.terminalId,
            'amount': walletPayData.amount,
            'merchant_id': walletPayData.merchantId,
            'from': walletPayData.from,
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

  Future<void> showCardReceipt({
    required BuildContext context,
    required PurchaseData cardPurchaseData,
    String Function(String)? globalTranslator,
  }) async {
    await Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (_) {
          final details = {
            'transaction_id': cardPurchaseData.hostResponseData.transactionId,
            'payment_id': cardPurchaseData.hostResponseData.paymentId,
            'stan': cardPurchaseData.hostResponseData.stan,
            'track_id': cardPurchaseData.hostResponseData.trackId,
            'rrn': cardPurchaseData.hostResponseData.rrn,
          };
          return TransactionStatusDialog(
            transactionStatus: TransactionStatus.success,
            details: details,
            globalTranslator: globalTranslator,
            onClose: () {
              Navigator.pop(_);
              Navigator.pop(_);
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
            },
          );
        },
      ),
    );
  }

  Future<void> showHistoryReceipt({
    required BuildContext context,
    required Map<String, dynamic> data,
    required bool? isCaptured,
    required bool? isSettled,
    required bool? isRefunded,
    required TransactionStatus status,
    String Function(String)? translator,
  }) async {
    await showDialog(
      context: context,
      builder: (_) {
        return TransactionStatusDialog(
          isCaptured: isCaptured,
          isRefunded: isRefunded,
          isSettled: isSettled,
          isTransactionDetails: true,
          transactionStatus: status,
          globalTranslator: translator,
          details: data,
          onClose: () {
            Navigator.pop(_);
          },
        );
      },
    );
  }
}
