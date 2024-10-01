import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/tooltip_widget.dart';
import 'package:amwal_pay_sdk/core/ui/amountcurrencywidget/amount_currency_widget_cubit.dart';
import 'package:amwal_pay_sdk/features/currency_field/presentation/currency_field.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AmountCurrencyWidget extends StatelessWidget {
  final AmountCurrencyWidgetCubit cubit;

  const AmountCurrencyWidget({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TooltipWidget(
                message: 'wallet_amount_tooltip'.translate(context),
                title: Text(
                  '${'amount_label'.translate(context)} *',
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              FormBuilder(
                key: cubit.formKey,
                child: TextFormField(
                  onChanged: (value) =>
                      cubit.amountValue = cubit.trimLeadingZeros(value),
                  maxLines: 1,
                  maxLength: 7,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(
                        1.0,
                        errorText: "min_amount_hint".translate(context),
                      ),
                      FormBuilderValidators.maxLength(
                        7,
                        errorText: 'invalid_input_field'.translate(
                          context,
                        ),
                      ),
                      FormBuilderValidators.minLength(
                        3,
                        errorText: 'invalid_input_field'.translate(
                          context,
                        ),
                      ),
                      FormBuilderValidators.match(
                        RegExp('^(?!.*^(000.00)).*\$'),
                        errorText: 'invalid_input_field'.translate(
                          context,
                        ),
                      ),
                      FormBuilderValidators.required(
                        errorText: 'required_field'.translate(
                          context,
                        ),
                      ),
                    ],
                  ),
                  inputFormatters: [
                    CurrencyTextInputFormatter.currency(
                      decimalDigits: 3,
                      symbol: '',
                      customPattern: '000.000',
                      enableNegative: false,
                    ),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '000.000',
                    focusColor: whiteColor,
                    counterText: '',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        CurrencyField(
          width: size.width * 0.35,
          height: 120,
          onChanged: (currencyData) => cubit.currencyData = currencyData,
        ),
      ],
    );
  }
}
