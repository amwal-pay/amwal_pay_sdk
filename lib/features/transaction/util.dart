import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/localization/app_localizations.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

import '../../amwal_sdk_settings/amwal_sdk_setting_container.dart';

extension OneTransactionExtension on OneTransaction {
  bool get isWallet =>
      transactionType == 'P2BPull' || transactionType == 'P2BPush';
  bool get isCard =>
      transactionType == 'Purchase' || transactionType == 'Authorize';

  TransactionStatus get status {
    if (responseCodeName == 'Approved') {
      return TransactionStatus.success;
    } else {
      return TransactionStatus.failed;
    }
  }

  String transactionAmount(BuildContext context) {
    final isEnglish = AppLocalizations.of(context)?.isEnLocale ?? true;
    var amount = this.amount.toStringAsFixed(3);
    if (isEnglish) {
      return ' ${currency.translate(context)} $amount';
    } else {
      return '  $amount ${currency.translate(context)}';
    }
  }



  String transactionDueAmount(BuildContext context, num dueAmount) {
    final isEnglish = AppLocalizations.of(context)?.isEnLocale ?? true;
    var amount =  dueAmount.toStringAsFixed(3);

    if (isEnglish) {

      return '  ${currency.translate(context)} $amount';
    } else {
      return '  $amount ${currency.translate(context)} ';
    }
  }
}

extension DateTimeFormatX on String {
  String formatDate(BuildContext context) {

    DateTime date = DateTime.parse(this).toUtc();



    DateFormat formatter = DateFormat(
        AmwalSdkSettingContainer.locale.languageCode.contains('en')
            ? 'a hh:mm dd/MM/yyyy'
            : 'yyyy/MM/dd hh:mm a',
        AmwalSdkSettingContainer.locale.languageCode);

    return formatter.format(date);
  }
}
