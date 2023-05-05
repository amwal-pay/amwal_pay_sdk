
import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/core/ui/cardinfoform/card_info_form_widget.dart';
import 'package:amwal_pay_sdk/core/ui/sale_card_feature_common_widgets.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction.dart';
import 'package:amwal_pay_sdk/core/ui/transactiondialog/transaction_status_dialog.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/card/presentation/widgets/otp_dialog.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide WatchContext;
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SaleByCardManualScreen extends ApiView<SaleByCardManualCubit> {
  final String amount;
  final int currencyId;
  final String currency;
  final String terminalId;
  final bool showAppBar;
  final String Function(String)? translator;

  const SaleByCardManualScreen({
    Key? key,
    required this.amount,
    required this.currencyId,
    required this.currency,
    required this.terminalId,
    this.showAppBar = true,
    this.translator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = PaymentArguments(
      terminalId: terminalId,
      amount: amount,
      currencyData: CurrencyData(
        idN: currencyId,
        name: currency,
        id: currencyId.toString(),
      ),
    );

    Future<String?> showOtpDialog() async {
      if (context.mounted) {
        final otpOrNull = await showDialog<String?>(
          context: context,
          builder: (_) => const OTPEntryDialog(),
        );
        return otpOrNull;
      } else {
        return null;
      }
    }

    Future<PurchaseData?> onPurchaseStepTwo(String otp) async {
      return await cubit.purchaseOtpStepTwo(
        args.amount,
        args.terminalId,
        otp,
      );
    }

    Future<void> showTransactionDialog(PurchaseData purchaseData) async {
      await Navigator.of(context).push(DialogRoute(
        context: context,
        builder: (_) {
          final details = {
            'transaction_id': purchaseData.hostResponseData.transactionId,
            'payment_id': purchaseData.hostResponseData.paymentId,
            'stan': purchaseData.hostResponseData.stan,
            'track_id': purchaseData.hostResponseData.trackId,
            'rrn': purchaseData.hostResponseData.rrn,
          };
          return TransactionStatusDialog(
            transactionStatus: TransactionStatus.success,
            details: details,
            globalTranslator: translator,
          );
        },
      ));
    }

    Future<void> onPurchaseWith3DS() async {
      String? otpOrNull;
      await cubit.purchaseOtpStepOne(
        args.amount,
        args.terminalId,
      );
      otpOrNull = await showOtpDialog();
      if (otpOrNull == null) {
        return;
      }
      final purchaseDataOrNull = await onPurchaseStepTwo(otpOrNull);

      if (purchaseDataOrNull != null && context.mounted) {
        await showTransactionDialog(purchaseDataOrNull);
      }
    }

    Future<void> purchaseWithOut3DS() async {
      final purchaseDataOrNull = await cubit.purchase(
        args.amount,
        args.terminalId,
      );
      if (purchaseDataOrNull != null && context.mounted) {
        await Navigator.of(context).push(
          DialogRoute(
            context: context,
            builder: (_) {
              final details = {
                'transaction_id':
                    purchaseDataOrNull.hostResponseData.transactionId,
                'payment_id': purchaseDataOrNull.hostResponseData.paymentId,
                'stan': purchaseDataOrNull.hostResponseData.stan,
                'track_id': purchaseDataOrNull.hostResponseData.trackId,
                'rrn': purchaseDataOrNull.hostResponseData.rrn,
              };
              return TransactionStatusDialog(
                transactionStatus: TransactionStatus.success,
                details: details,
                globalTranslator: translator,
              );
            },
          ),
        );
      }
    }

    return BlocListener<SaleByCardManualCubit, ICubitState<PurchaseResponse>>(
      bloc: cubit,
      listener: (_, state) {
        final record = state.mapOrNull(success: (value) => value.uiModel.data);
      },
      child: Scaffold(
        backgroundColor: lightGeryColor,
        appBar: !showAppBar
            ? null
            : AppBar(
                backgroundColor: whiteColor,
                leading: InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                ),
                title: Text(
                  'card_details_label'.translate(
                    context,
                    globalTranslator: translator,
                  ),
                  key: const Key('cardDetails'),
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        body: SingleChildScrollView(
          key: const Key('cardDetailsScroll'),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 30,
            ),
            child: FormBuilder(
              key: cubit.formKey,
              child: Column(
                children: [
                  SaleCardFeatureCommonWidgets.merchantAndAmountInfo(
                    context,
                    args,
                    translator: translator,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CardInfoFormWidget(globalTranslator: translator),
                  const SizedBox(
                    height: 40,
                  ),
                  AppButton(
                    key: const Key('confirmButton'),
                    onPressed: () async {
                      if (cubit.formKey.currentState!.validate()) {
                        if (!args.is3DS) {
                          await onPurchaseWith3DS();
                        } else {
                          await purchaseWithOut3DS();
                        }
                      }
                    },
                    child: Text(
                      'confirm'.translate(
                        context,
                        globalTranslator: translator,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  const AcceptedPaymentMethodsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
