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
    var amount = this.amount.toStringAsFixed(3);
    return '  $amount ${currency.translate(context)}';

  }



  String transactionDueAmount(BuildContext context, num dueAmount) {
    var amount =  dueAmount.toStringAsFixed(3);
    return '  $amount ${currency.translate(context)} ';
  }
}

extension DateTimeFormatX on String {
  String formatDate(BuildContext context) {

    DateTime date = DateTime.parse(this);



    DateFormat formatter = DateFormat(
        AmwalSdkSettingContainer.locale.languageCode.contains('en')
            ? 'dd/MM/yyyy hh:mm a'
            : 'yyyy/MM/dd hh:mm a',
        AmwalSdkSettingContainer.locale.languageCode);

    return formatter.format(date);
  }
}
