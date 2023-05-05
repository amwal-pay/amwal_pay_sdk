import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AmountCurrencyWidgetCubit extends Cubit {
  AmountCurrencyWidgetCubit() : super(null);

  String amountValue = '';
  CurrencyData? currencyData;
  final formKey = GlobalKey<FormBuilderState>();

  bool validateAmountInput() {
    return amountValue.isNotEmpty &&
        currencyData != null &&
        formKey.currentState!.validate();
  }
}
