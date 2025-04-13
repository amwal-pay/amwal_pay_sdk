import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/transaction_manager/i_card_transaction_manager.dart';
import 'package:amwal_pay_sdk/features/card/transaction_manager/transaction_util_dialog.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/ui/error_dialog.dart';
import '../../../localization/app_localizations_setup.dart';
import '../presentation/thrree_ds_web_view_page.dart';

class AmwalCardTransactionManager extends ICardTransactionManager {
  @override
  final BuildContext context;
  @override
  final String Function(String p1)? translator;

  @override
  final OnPayCallback? onPay;

  @override
  final EventCallback? log;

  @override
  final SaleByCardManualCubit saleByCardManualCubit;

  @override
  final PaymentArguments paymentArguments;

  @override
  final GetOneTransactionByIdUseCase getOneTransactionByIdUseCase;

  AmwalCardTransactionManager({
    required this.context,
    required this.saleByCardManualCubit,
    required this.paymentArguments,
    required this.getOneTransactionByIdUseCase,
    this.translator,
    this.onPay,
    this.log,
  });

  Future<Either<Map<String, dynamic>, PurchaseData>> onPurchaseStepTwo({
    required String otp,
    required String transactionId,
    required String originTransactionId,
  }) async {
    return await saleByCardManualCubit.purchaseOtpStepTwo(
      paymentArguments.amount,
      paymentArguments.terminalId,
      paymentArguments.currencyData!.idN,
      paymentArguments.merchantId,
      transactionId,
      otp,
      originTransactionId,
      saleByCardManualCubit.isTokenized,
    );
  }

  @override
  Future<void> onPurchaseWith3DS({
    required void Function(BuildContext) dismissLoader,
    void Function(void Function(BuildContext))? setContext,
  }) async {
    void Function()? dismissFn;
    final purchaseData = await saleByCardManualCubit.purchaseOtpStepOne(
      paymentArguments.amount,
      paymentArguments.terminalId,
      paymentArguments.currencyData!.idN,
      paymentArguments.merchantId,
      paymentArguments.transactionId,
      context,
      dismissLoaderTrigger: (dismiss) {
        dismissFn = dismiss;
      },
    );
    dismissFn?.call();
    if (purchaseData == null) return;
    if (purchaseData.hostResponseData.accessUrl != null && context.mounted) {
      await handleAccessUrl(
        url: purchaseData.hostResponseData.accessUrl!,
        setContext: setContext,
      );
    } else if (purchaseData.isOtpRequired && context.mounted) {
      await onOtpRequired(
        originalTransactionId: purchaseData.transactionId,
      );
    } else {
      if (context.mounted) {
        saleByCardManualCubit.formKey.currentState?.reset();
        await onTransactionCreated(
          purchaseData.transactionId,
          Right(purchaseData),
          setContext,
        );
      } else {
        if (context.mounted) dismissLoader(context);
      }
    }
  }

  @override
  Future<void> handleAccessUrl({
    required String url,
    void Function(void Function(BuildContext))? setContext,
  }) async {
    await AmwalSdkNavigator.amwalNavigatorObserver.navigator?.push(
      MaterialPageRoute(
        builder: (context) => ThreeDSWebViewPage(
          url: url,
          onTransactionFound: (purchaseData) async {
            await receiptAfterComplete(
              purchaseData.transactionId,
              Right(purchaseData),
              setContext: setContext,
            );
          },
          onTransactionIdFound: (transactionId) async {
            // await receiptAfterComplete(
            //   transactionId,
            //   null,
            //   setContext: setContext,
            // );
          },
        ),
      ),
    );
  }

  @override
  Future<void> onOtpRequired({
    String? otpOrNull,
    required String originalTransactionId,
  }) async {
    String? otpOrNull;
    Either<Map<String, dynamic>, PurchaseData> purchaseDataOrFail;
    int errorCounter = 0;
    String transactionId = const Uuid().v1();
    await showOtpDialog(
      onSubmit: (otp, dialogContext) async {
        otpOrNull = otp;
        purchaseDataOrFail = await onPurchaseStepTwo(
          otp: otpOrNull!,
          transactionId: transactionId,
          originTransactionId: originalTransactionId,
        );
        if (purchaseDataOrFail.isLeft()) {
          errorCounter++;
          transactionId = const Uuid().v1();
          if (errorCounter >= 3) {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
              TransactionUtilDialog.showTransactionCancellationDialog(
                merchantId: paymentArguments.merchantId,
                transactionId: originalTransactionId,
                amount: paymentArguments.amount,
                currency: paymentArguments.currencyData!.idN,
                log: log,
              );
            }
          }
          return;
        } else if (purchaseDataOrFail.isRight() && context.mounted) {
          await onTransactionCreated(
            transactionId,
            purchaseDataOrFail,
            null,
          );
        }
      },
    );
    if (otpOrNull?.isEmpty ?? true) {
      return;
    }
  }

  @override
  Future<void> receiptAfterComplete(
    String transactionId,
    Either<Map<String, dynamic>, PurchaseData>? purchaseDataOrFail, {
    void Function()? dismissFn,
    void Function(void Function(BuildContext))? setContext,
  }) async {
    final purchaseDataOrNull = purchaseDataOrFail?.fold((l) => null, (r) => r);
    if (purchaseDataOrNull != null) {
      TransactionUtilDialog.showReceiptWithTransactionSettings(
        purchaseData: purchaseDataOrNull,
        context: context,
      );
    } else {
      saleByCardManualCubit.showLoader();

      onPay?.call(
        (settings) async {
          saleByCardManualCubit.initial();
          await ReceiptHandler.instance.showCardReceipt(
            context:
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
            settings: settings,
          );
        },
      );
    }
  }
}
