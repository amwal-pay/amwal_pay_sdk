import 'package:amwal_pay_sdk/core/ui/error_dialog.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';


import '../../../amwal_sdk_settings/amwal_sdk_setting_container.dart';
import '../../../core/ui/transactiondialog/transaction.dart';
import '../../../core/ui/transactiondialog/transaction_details_settings.dart';
import '../../../localization/app_localizations_setup.dart';
import '../../../navigator/sdk_navigator.dart';
import '../../receipt/receipt_handler.dart';
import '../data/models/response/purchase_response.dart';

class TransactionUtilDialog {
  static   showTransactionCancellationDialog({
    required int merchantId,
    required String transactionId,
    required String amount,
    required int currency,
    Function(String, Map<String, dynamic>)? log,
  }) {
    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();

    if (AmwalSdkNavigator.amwalNavigatorObserver.navigator != null) {
      final context =
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context;

      log?.call('payment_abandoned', {
        "user_id": merchantId,
        "transaction_id": transactionId,
        "payment_amount": amount,
        "payment_method": 'Pay by Card',
        "currency": currency,
      });

      return showDialog(
        context: context.mounted ? context : context,
        builder: (_) => Localizations(
          locale: AmwalSdkSettingContainer.locale,
          delegates: const [...AppLocalizationsSetup.localizationsDelegates],
          child: ErrorDialog(
            locale: AmwalSdkSettingContainer.locale,
            title: "err".translate(context) ?? '',
            message: "transaction_cancel".translate(context),
            resetState: () {
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
            },
          ),
        ),
      );
    }
  }

  static TransactionDetailsSettings generateTransactionSettingsFromPurchaseData(
      PurchaseData purchaseData,
      BuildContext context,
      ) {

    final amount = (num.tryParse(purchaseData.amount ?? "0") ?? 0).toStringAsFixed(3);
    final amountString =
        '  $amount ${purchaseData.currency?.translate(context) ?? ''}';
    return TransactionDetailsSettings(
      locale: AmwalSdkSettingContainer.locale,
      amount: num.tryParse(purchaseData.amount ?? "0") ?? 0,
      transactionDisplayName: purchaseData.transactionTypeDisplayName ?? "",
      isSuccess: purchaseData.message != 'canceled',
      transactionStatus: purchaseData.message == 'canceled' ? TransactionStatus.failed : TransactionStatus.success,
      transactionType: purchaseData.message,
      isTransactionDetails: false,
      globalTranslator: (string) => string.translate(context),
      transactionId: purchaseData.transactionId,
      details: {
        'merchant_name_label': purchaseData.merchantName,
        'ref_no': purchaseData.gatewayTransactionReference ?? purchaseData.hostResponseData.rrn,
        'merchant_id': purchaseData.merchantId,
        'terminal_id': purchaseData.terminalId,
        'date_time': purchaseData.transactionDate,
        'amount': amountString,
      },
    );
  }

  static Future<void> showReceiptWithTransactionSettings({
    required PurchaseData? purchaseData,
    required BuildContext context,
  }) async {
    if (purchaseData == null) return;

    final setting = TransactionUtilDialog.generateTransactionSettingsFromPurchaseData(
      purchaseData,
      context,
    );

    await ReceiptHandler.instance.showHistoryReceipt(
      context: AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
      settings: setting.copyWith(onClose: () {
        AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
        AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
      }),
    );
  }
}
