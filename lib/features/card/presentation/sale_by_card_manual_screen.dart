import 'package:amwal_pay_sdk/core/apiview/api_view.dart';
import 'package:amwal_pay_sdk/core/base_state/base_cubit_state.dart';
import 'package:amwal_pay_sdk/core/loader_mixin.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/accepted_payment_methods_widget.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/core/ui/cardinfoform/card_info_form_widget.dart';
import 'package:amwal_pay_sdk/core/ui/sale_card_feature_common_widgets.dart';
import 'package:amwal_pay_sdk/features/card/amwal_salebycard_sdk.dart';
import 'package:amwal_pay_sdk/features/card/cubit/card_transaction_manager.dart';
import 'package:amwal_pay_sdk/features/card/cubit/sale_by_card_manual_cubit.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/purchase_response.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/features/payment_argument.dart';
import 'package:amwal_pay_sdk/features/transaction/domain/use_case/get_transaction_by_Id.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide WatchContext;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:uuid/uuid.dart';

class SaleByCardManualScreen extends ApiView<SaleByCardManualCubit>
    with LoaderMixin {
  final String amount;
  final int currencyId;
  final String currency;
  final String terminalId;
  final int merchantId;
  final String merchantName;
  final bool showAppBar;
  final String? transactionId;
  final String Function(String)? translator;
  final Locale locale;

  const SaleByCardManualScreen({
    Key? key,
    required this.amount,
    required this.currencyId,
    required this.currency,
    required this.terminalId,
    required this.merchantId,
    required this.locale,
    required this.merchantName,
    this.transactionId,
    this.showAppBar = true,
    this.translator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = PaymentArguments(
      terminalId: terminalId,
      amount: amount,
      merchantId: merchantId,
      merchantName: merchantName,
      currencyData: CurrencyData(
        idN: currencyId,
        name: currency,
        id: currencyId.toString(),
      ),
    );

    return BlocListener<SaleByCardManualCubit, ICubitState<PurchaseResponse>>(
      bloc: cubit,
      listener: (_, state) {},
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
                      final isValid = cubit.formKey.currentState!.validate();
                      if (isValid) {
                        await CardTransactionManager.instance.onPurchaseWith3DS(
                          cubit: cubit,
                          args: args,
                          context: context,
                          getOneTransactionByIdUseCase: CardInjector.instance
                              .get<GetOneTransactionByIdUseCase>(),
                          dismissLoader: dismissDialog,
                        );
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
