import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/presentation/widgets/otp_dialog.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class ICardTransactionManager {
  BuildContext get context;

  String Function(String)? get translator;

  SaleByCardManualCubit get saleByCardManualCubit;

  PaymentArguments get paymentArguments;

  OnPayCallback? get onPay;

  EventCallback? get log;

  GetOneTransactionByIdUseCase get getOneTransactionByIdUseCase;

  Future<String?> showOtpDialog({
    required void Function(String, BuildContext) onSubmit,
  }) async {
    final otpOrNull = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => OTPEntryDialog(
        onSubmit: onSubmit,
        otpVerificationString: 'otp_verification'.translate(
          context,
          globalTranslator: translator,
        ),
        verifyString: 'verify'.translate(
          context,
          globalTranslator: translator,
        ),
      ),
    );
    return otpOrNull;
  }

  Future<void> onPurchaseWith3DS({
    required void Function(BuildContext) dismissLoader,
    void Function(void Function(BuildContext))? setContext,
  });

  Future<void> onOtpRequired({
    String? otpOrNull,
    required String originalTransactionId,
  });

  Future<void> handleAccessUrl({
    required String url,
    void Function(void Function(BuildContext))? setContext,
  });

  Future<void> onTransactionFailed({
    required String transactionId,
    required String message,
  }) async {
    log?.call('payment_failed', {
      "user_id": paymentArguments.merchantId,
      "transaction_id": transactionId,
      "payment_amount": paymentArguments.amount,
      "payment_method": 'Pay by Card',
      'failed_reason': message,
      "currency": paymentArguments.currencyData?.name ?? '',
    });
  }

  Future<void> onTransactionCreated(
    String transactionId,
    Either<Map<String, dynamic>, PurchaseData>? purchaseDataOrFail,
  ) async {
    await receiptAfterComplete(
      transactionId,
      purchaseDataOrFail,
    );
  }

  Future<void> receiptAfterComplete(
    String transactionId,
    Either<Map<String, dynamic>, PurchaseData>? purchaseDataOrFail, {
    void Function()? dismissFn,
    void Function(void Function(BuildContext))? setContext,
  });
}
