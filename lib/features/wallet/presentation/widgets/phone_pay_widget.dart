import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/inputfields/phone_input_field.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';

import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PhonePayWidget extends StatelessWidget {
  final String Function(String)? globalTranslator;

  const PhonePayWidget({Key? key, this.globalTranslator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletCubit = WalletInjector.instance.get<SaleByWalletCubit>();
    return FormBuilder(
      key: walletCubit.formKey,
      child: Column(
        children: [
          Text(
            'transaction_by_label'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            style: const TextStyle(
              color: blackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          PhoneInputField(
            // globalTranslator: globalTranslator,
            widgetTitle: 'wallet_mobile_number'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            widgetHint: 'phone_number'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            onChange: (value) => walletCubit.phoneNumber = value,
          ),
          if (walletCubit.state.verified)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.done,
                    color: successColor,
                  ),
                  Text(
                    walletCubit.customerNameFromApi,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
