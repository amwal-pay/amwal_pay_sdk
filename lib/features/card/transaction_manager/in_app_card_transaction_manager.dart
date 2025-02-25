import 'package:amwal_pay_sdk/amwal_pay_sdk.dart';
import 'package:amwal_pay_sdk/amwal_sdk_settings/amwal_sdk_setting_container.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_details_settings.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/transaction_manager/i_card_transaction_manager.dart';
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
import '../presentation/thrree_ds_web_view_page.dart';

class InAppCardTransactionManager extends ICardTransactionManager {
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

  final void Function(String?)? customerCallback;
  final void Function(String?)? onResponse;

  final String? customerId;

  final String? customerTokenId;
  final String? cvv;

  InAppCardTransactionManager({
    this.cvv,
    this.customerTokenId,
    this.customerId,
    this.customerCallback,
    this.onResponse,
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
    CustomerToken? token,
  }) async {
    void Function()? dismissFn;
    PurchaseData? purchaseData;
    if (token != null) {
      purchaseData = await saleByCardManualCubit.payWithToken(
        paymentArguments.amount,
        paymentArguments.terminalId,
        paymentArguments.currencyData!.idN,
        0,
        paymentArguments.transactionId,
        context,
        isTokenized: saleByCardManualCubit.isTokenized,
        customerId: customerId,
        customerTokenId: customerTokenId,
        cvv: cvv,
        dismissLoaderTrigger: (dismiss) {
          dismissFn = dismiss;
        },
      );
    } else {
      purchaseData = await saleByCardManualCubit.purchaseOtpStepOne(
        paymentArguments.amount,
        paymentArguments.terminalId,
        paymentArguments.currencyData!.idN,
        0,
        paymentArguments.transactionId,
        context,
        isTokenized: saleByCardManualCubit.isTokenized,
        dismissLoaderTrigger: (dismiss) {
          dismissFn = dismiss;
        },
      );
    }
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
      } else {
        if (context.mounted) dismissLoader(context);
      }
      customerCallback?.call(purchaseData.customerId);
      onResponse?.call(purchaseData.toMap().toString());
      await onTransactionCreated(
        purchaseData.transactionId,
        Right(purchaseData),
        setContext,
      );
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
            if(purchaseData.customerId != null && purchaseData.customerId!.isNotEmpty &&
                purchaseData.customerId != "null"
            ) {
              AmwalPaySdk.settings?.customerCallback?.call(purchaseData.customerId);
            }


            AmwalPaySdk.settings?.onResponse?.call(purchaseData.toMap().toString());

            await receiptAfterComplete(
              purchaseData.transactionId,
              Right(purchaseData),
              setContext: setContext,
            );
          },
          onTransactionIdFound: (transactionId) async {
            await receiptAfterComplete(
              transactionId,
              null,
              setContext: setContext,
            );
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
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
              AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
              if (AmwalSdkNavigator.amwalNavigatorObserver.navigator != null) {
                final context =
                    AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context;
                log?.call('payment_abandoned', {
                  "user_id": paymentArguments.merchantId,
                  "transaction_id": transactionId,
                  "payment_amount": paymentArguments.amount,
                  "payment_method": 'Pay by Card',
                  "currency": paymentArguments.currencyData?.name ?? '',
                });
                return showDialog(
                  context: context.mounted ? context : context,
                  builder: (_) => Localizations(
                    locale: AmwalSdkSettingContainer.locale,
                    delegates: const [
                      ...AppLocalizationsSetup.localizationsDelegates
                    ],
                    child: ErrorDialog(
                      locale: AmwalSdkSettingContainer.locale,
                      title: "err".translate(context) ?? '',
                      message: "transaction_cancel".translate(context),
                      resetState: () {
                        AmwalSdkNavigator.amwalNavigatorObserver.navigator!
                            .pop();
                      },
                    ),
                  ),
                );
              }
            }
          }
          return;
        } else if (purchaseDataOrFail.isRight() && context.mounted) {
          final purchaseData = purchaseDataOrFail.fold((_) => null, (r) => r);
          customerCallback?.call(purchaseData?.customerId);
          onResponse?.call(purchaseData?.toMap().toString());

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

  Future<void> _showReceiptFromPurchase(
    PurchaseData purchaseData,
    setContext,
  ) async {
    BuildContext lContext = context;
    setContext?.call((ctx) {
      lContext = ctx;
    });
    final settings = _generateTransactionSettingsFromPurchaseData(
      purchaseData,
      lContext,
    );

    await ReceiptHandler.instance.showHistoryReceipt(
      context: lContext,
      settings: settings.copyWith(
        onClose: () {
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
          AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
        },
      ),
    );
  }

  Future<void> _showReceiptFromTransaction(
    String transactionId,
    void Function()? dismissFn,
    void Function(void Function(BuildContext))? setContext,
  ) async {
    OneTransaction? oneTransaction;
    final oneTransactionResponse = await getOneTransactionByIdUseCase.invoke(
      {
        'transactionId': transactionId,
        'merchantId': paymentArguments.merchantId,
      },
    );
    dismissFn?.call();
    oneTransactionResponse.whenOrNull(
      success: (value) {
        oneTransaction = value.data;
        log?.call(
          'payment_successfully',
          {
            "user_id": paymentArguments.merchantId,
            "transaction_id": value.data?.id,
            "payment_amount": paymentArguments.amount,
            "payment_method": 'Pay by Card',
            "currency": paymentArguments.currencyData?.name ?? '',
          },
        );
      },
      error: (message, errorList) {
        log?.call(
          'payment_failed',
          {
            "user_id": paymentArguments.merchantId,
            "transaction_id": transactionId,
            "payment_amount": paymentArguments.amount,
            "payment_method": 'Pay by Card',
            'failed_reason': message,
            "currency": paymentArguments.currencyData?.name ?? '',
          },
        );
      },
    );
    final navigator = AmwalSdkNavigator.amwalNavigatorObserver.navigator;
    navigator?.pop();
    if (navigator != null) {
      log?.call('payment_abandoned', {
        "user_id": paymentArguments.merchantId,
        "transaction_id": transactionId,
        "payment_amount": paymentArguments.amount,
        "payment_method": 'Pay by Card',
        "currency": paymentArguments.currencyData?.name ?? '',
      });
      showDialog(
        context:
            navigator.context.mounted ? navigator.context : navigator.context,
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
    BuildContext lContext = context;
    setContext?.call((ctx) {
      lContext = ctx;
    });
    saleByCardManualCubit.initial();
    if (oneTransaction != null) {
      await ReceiptHandler.instance.showHistoryReceipt(
        context: lContext.mounted ? lContext : lContext,
        settings: _generateTransactionSettings(
          oneTransaction!,
          lContext.mounted ? lContext : lContext,
        ).copyWith(
          onClose: () {
            AmwalSdkNavigator.amwalNavigatorObserver.navigator!.pop();
          },
        ),
      );
    }
  }

  @override
  Future<void> receiptAfterComplete(
    String transactionId,
    Either<Map<String, dynamic>, PurchaseData>? purchaseDataOrFail, {
    void Function()? dismissFn,
    void Function(void Function(BuildContext))? setContext,
  }) async {
    final purchaseData = purchaseDataOrFail?.fold((_) => null, (r) => r);

    if (purchaseData != null) {
      await _showReceiptFromPurchase(purchaseData, setContext);
    } else {
      await _showReceiptFromTransaction(
        transactionId,
        dismissFn,
        setContext,
      );
    }
  }

  TransactionDetailsSettings _generateTransactionSettings(
    OneTransaction oneTransaction,
    BuildContext context,
  ) {
    return TransactionDetailsSettings(
      locale: AmwalSdkSettingContainer.locale,
      amount: oneTransaction.amount,
      transactionDisplayName: oneTransaction.transactionTypeDisplayName ?? "",
      isSuccess: oneTransaction.responseCodeName == 'Approved',
      transactionStatus: oneTransaction.responseCodeName == 'Approved'
          ? TransactionStatus.success
          : TransactionStatus.failed,
      transactionType: oneTransaction.transactionType ?? "",
      isTransactionDetails: false,
      globalTranslator: (string) => string.translate(context),
      transactionId: oneTransaction.id,
      details: {
        'merchant_name_label': oneTransaction.merchantName,
        'ref_no': oneTransaction.gatewayTransactionReference ?? oneTransaction.idN,
        'merchant_id': oneTransaction.merchantId,
        'terminal_id': oneTransaction.terminalId,
        'date_time': oneTransaction.transactionTime?.formatDate(context),
        'amount': oneTransaction.transactionAmount(context),
      },
    );
  }

  TransactionDetailsSettings _generateTransactionSettingsFromPurchaseData(
    PurchaseData purchaseData,
    BuildContext context,
  ) {
    final amount = (num.tryParse((purchaseData.amount ?? "0")) ?? 0).toStringAsFixed(3);
    final amountString =
        '  $amount ${purchaseData.currency?.translate(context)}';
    return TransactionDetailsSettings(
      locale: AmwalSdkSettingContainer.locale,
      amount: num.tryParse(purchaseData.amount ?? "0") ?? 0,
      transactionDisplayName: purchaseData.transactionTypeDisplayName ?? "",
      isSuccess: purchaseData.message.toLowerCase() != 'canceled',
      transactionStatus: purchaseData.message.toLowerCase() != 'canceled'
          ? TransactionStatus.success
          : TransactionStatus.failed,
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
}
