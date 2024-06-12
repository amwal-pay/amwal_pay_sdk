import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/core/networking/constants.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/presentation/widgets/otp_dialog.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/data/models/response/one_transaction_response.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/features/transaction/util.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/ui/error_dialog.dart';
import '../../../localization/app_localizations_setup.dart';

class CardTransactionManager {
  const CardTransactionManager._();
  static CardTransactionManager get instance =>
      const CardTransactionManager._();

  Future<String?> showOtpDialog({
    required BuildContext context,
    String Function(String)? translator,
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

  Future<Either<Map<String, dynamic>, PurchaseData>> onPurchaseStepTwo({
    required String otp,
    required String transactionId,
    required String originTransactionId,
    required SaleByCardManualCubit cubit,
    required PaymentArguments args,
  }) async {
    return await cubit.purchaseOtpStepTwo(
      args.amount,
      args.terminalId,
      args.currencyData!.idN,
      args.merchantId,
      transactionId,
      otp,
      originTransactionId,
    );
  }

  Future<void> onPurchaseWith3DS({
    required SaleByCardManualCubit cubit,
    required PaymentArguments args,
    required BuildContext context,
    String Function(String)? translator,
    OnPayCallback? onPay,
    required GetOneTransactionByIdUseCase getOneTransactionByIdUseCase,
    required void Function(BuildContext) dismissLoader,
  }) async {
    String? otpOrNull;
    final purchaseData = await cubit.purchaseOtpStepOne(
      args.amount,
      args.terminalId,
      args.currencyData!.idN,
      args.merchantId,
      args.transactionId,
      context,
    );
    if (purchaseData == null) return;
    if (purchaseData.isOtpRequired && context.mounted) {
      Either<Map<String, dynamic>, PurchaseData> purchaseDataOrFail;
       int errorCounter = 0;

      var transactionId = const Uuid().v1();
      await showOtpDialog(
        context: context,
        translator: translator,
        onSubmit: (otp, dialogContext) async {
          otpOrNull = otp;
          purchaseDataOrFail = await onPurchaseStepTwo(
            args: args,
            otp: otpOrNull!,
            transactionId: transactionId,
            cubit: cubit,
            originTransactionId: purchaseData.transactionId,
          );
          if (purchaseDataOrFail.isLeft()) {
            errorCounter++;
            transactionId = const Uuid().v1();
            if (errorCounter >= 3) {

              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();


                if (AmwalSdkNavigator.amwalNavigatorObserver.navigator != null) {
                  return showDialog(
                    context:
                    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context,
                    builder: (_) => Localizations(
                      locale: AmwalSdkSettingContainer.locale,
                      delegates: const [
                        ...AppLocalizationsSetup.localizationsDelegates
                      ],
                      child: ErrorDialog(
                        locale: AmwalSdkSettingContainer.locale,
                        title: "err".translate(context) ?? '',
                        message: "transaction_cancel".translate(context), resetState: () { AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop(); },

                      ),
                    ),
                  );
                }


              }
            }
            return;
          } else if (purchaseDataOrFail.isRight() && context.mounted) {
            Navigator.of(dialogContext).pop();
            if (NetworkConstants.isSdkInApp) {
              cubit.showLoader();
              final oneTransactionResponse =
                  await getOneTransactionByIdUseCase.invoke(
                {
                  'transactionId':  transactionId,
                  'merchantId': args.merchantId,
                },
              );
              final oneTransaction = oneTransactionResponse.mapOrNull(
                success: (value) => value.data.data,
              );
              cubit.initial();
              if (oneTransaction != null && context.mounted) {
                await ReceiptHandler.instance.showHistoryReceipt(
                  context: context,
                  settings:
                      _generateTransactionSettings(oneTransaction, context)
                          .copyWith(
                    onClose: () {
                      AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
                    },
                  ),
                );
              }
            } else {
              cubit.showLoader();
              onPay?.call(
                (settings) async {
                  cubit.initial();
                  await ReceiptHandler.instance.showCardReceipt(
                    context: context,
                    settings: settings,
                  );
                },
                purchaseDataOrFail.fold((l) => null, (r) => r.transactionId),
              );
            }
          }
        },
      );
      if (otpOrNull?.isEmpty ?? true) {
        return;
      }
    } else {
      if (context.mounted) {
        cubit.formKey.currentState?.reset();
        onPay?.call((settings) async {
          await ReceiptHandler.instance.showCardReceipt(
            context: context,
            settings: settings,
          );
          if (context.mounted) dismissLoader(context);
        });
      } else {
        if (context.mounted) dismissLoader(context);
      }
    }
  }

  TransactionDetailsSettings _generateTransactionSettings(
    OneTransaction oneTransaction,
    BuildContext context,
  ) {
    return TransactionDetailsSettings(
      locale: AmwalSdkSettingContainer.locale,
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
}
