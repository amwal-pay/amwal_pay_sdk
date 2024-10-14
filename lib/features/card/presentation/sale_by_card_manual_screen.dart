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
import 'package:amwal_pay_sdk/presentation/sdk_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide WatchContext;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:uuid/uuid.dart';

class SaleByCardManualScreen extends StatefulApiView<SaleByCardManualCubit>
    with LoaderMixin {
  final String amount;
  final int currencyId;
  final String currency;
  final String terminalId;
  final int merchantId;
  final bool showAppBar;
  final String? transactionId;
  final String Function(String)? translator;
  final Locale locale;
  final OnPayCallback onPay;

  const SaleByCardManualScreen({
    Key? key,
    required this.amount,
    required this.currencyId,
    required this.currency,
    required this.terminalId,
    required this.merchantId,
    required this.locale,
    required this.onPay,
    this.transactionId,
    this.showAppBar = true,
    this.translator,
  }) : super(key: key);

  @override
  State<SaleByCardManualScreen> createState() => _SaleByCardManualScreenState();
}

class _SaleByCardManualScreenState extends State<SaleByCardManualScreen> {
  late FocusNode _cardFocusNode;
  late FocusNode _expireMonthNode;
  late FocusNode _expireYearNode;
  late FocusNode _cvvNode;

  @override
  void initState() {
    super.initState();
    _cardFocusNode = FocusNode();
    _expireMonthNode = FocusNode();
    _expireYearNode = FocusNode();
    _cvvNode = FocusNode();
  }

  @override
  void dispose() {
    _cardFocusNode.dispose();
    _expireMonthNode.dispose();
    _expireYearNode.dispose();
    _cvvNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = PaymentArguments(
      terminalId: widget.terminalId,
      amount: widget.amount,
      merchantId: widget.merchantId,
      transactionId: widget.transactionId,
      currencyData: CurrencyData(
        idN: widget.currencyId,
        name: widget.currency,
        id: widget.currencyId.toString(),
      ),
    );

    return BlocListener<SaleByCardManualCubit, ICubitState<PurchaseResponse>>(
      bloc: widget.cubit,
      listener: (_, state) {},
      child: Scaffold(
        backgroundColor: lightGeryColor,
        appBar: !widget.showAppBar
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
                    globalTranslator: widget.translator,
                  ),
                  key: const Key('cardDetails'),
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        body: KeyboardActions(
          config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
              actions: [
                KeyboardActionsItem(
                  focusNode: _cardFocusNode,
                  displayArrows: false,
                ),
                KeyboardActionsItem(
                  focusNode: _expireMonthNode,
                  displayArrows: false,
                ),
                KeyboardActionsItem(
                  focusNode: _expireYearNode,
                  displayArrows: false,
                ),
                KeyboardActionsItem(
                  focusNode: _cvvNode,
                  displayArrows: false,
                ),
              ]),
          child: SingleChildScrollView(
            key: const Key('cardDetailsScroll'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 30,
              ),
              child: FormBuilder(
                key: widget.cubit.formKey,
                child: Column(
                  children: [
                    SaleCardFeatureCommonWidgets.merchantAndAmountInfo(
                      context,
                      args,
                      translator: widget.translator,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CardInfoFormWidget(
                      globalTranslator: widget.translator,
                      cardFocusNode: _cardFocusNode,
                      expireMonthFocusNode: _expireMonthNode,
                      expireYearFocusNode: _expireYearNode,
                      cvvFocusNode: _cvvNode,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AppButton(
                      key: const Key('confirmButton'),
                      onPressed: () async {
                        final isValid =
                            widget.cubit.formKey.currentState!.validate();
                        if (isValid) {
                          //TODO test after server work done
                          args.transactionId = const Uuid().v1();
                          await CardTransactionManager.instance
                              .onPurchaseWith3DS(
                                  cubit: widget.cubit,
                                  args: args,
                                  context: context,
                                  getOneTransactionByIdUseCase: CardInjector
                                      .instance
                                      .get<GetOneTransactionByIdUseCase>(),
                                  dismissLoader: widget.dismissDialog,
                                  onPay: widget.onPay,
                                  setContext: (cb) {
                                    cb(context);
                                  });
                        }
                      },
                      child: Text(
                        'confirm'.translate(
                          context,
                          globalTranslator: widget.translator,
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
      ),
    );
  }
}
