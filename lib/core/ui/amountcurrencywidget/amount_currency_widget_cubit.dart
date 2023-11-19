import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/features/currency_field/data/models/response/currency_response.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AmountCurrencyWidgetCubit extends Cubit {
  AmountCurrencyWidgetCubit() : super(null);

  String amountValue = '';
  CurrencyData? currencyData;
  final formKey = GlobalKey<FormBuilderState>();


  String trimLeadingZeros(String? input) {
    if(input == null) return '';
    return input.replaceFirst(RegExp(r'^0+'), '');
  }


  String? validateFields({
    required BuildContext context,
    required String? terminal,
  }) {

    if (amountValue.isEmpty||amountValue== "00.00") {
      return 'enter_amount'.translate(context);
    } else if (currencyData == null) {
      return 'select_currency'.translate(context);
    } else if (terminal == null) {
      return 'choose-terminal'.translate(context);
    } else {
      return null;
    }
  }

  void showErrorSnackBar({
    required BuildContext context,
    required String message,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: redColor,
    );
    scaffoldMessenger.showSnackBar(snackBar);
  }
}
