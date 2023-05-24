import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';

class TransactionDetailsSettings {
  final TransactionStatus transactionStatus;
  final String transactionType;
  final Map<String, dynamic>? details;
  final bool? isRefunded;
  final bool? isCaptured;
  final bool? isSettled;
  final void Function()? onClose;
  final bool isTransactionDetails;
  final String Function(String)? globalTranslator;

  const TransactionDetailsSettings({
    required this.transactionStatus,
    required this.transactionType,
    this.details,
    this.isRefunded,
    this.isCaptured,
    this.isSettled,
    this.onClose,
    required this.isTransactionDetails,
    this.globalTranslator,
  });

  TransactionDetailsSettings copyWith({
    TransactionStatus? transactionStatus,
    String? transactionType,
    Map<String, dynamic>? details,
    bool? isRefunded,
    bool? isCaptured,
    bool? isSettled,
    void Function()? onClose,
    bool? isTransactionDetails,
    String Function(String)? globalTranslator,
  }) {
    return TransactionDetailsSettings(
      transactionStatus: transactionStatus ?? this.transactionStatus,
      transactionType: transactionType ?? this.transactionType,
      details: details ?? this.details,
      isRefunded: isRefunded ?? this.isRefunded,
      isCaptured: isCaptured ?? this.isCaptured,
      isSettled: isSettled ?? this.isSettled,
      onClose: onClose ?? this.onClose,
      isTransactionDetails: isTransactionDetails ?? this.isTransactionDetails,
      globalTranslator: globalTranslator ?? this.globalTranslator,
    );
  }
}
