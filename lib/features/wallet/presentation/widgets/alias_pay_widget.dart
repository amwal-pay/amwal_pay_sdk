import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/inputfields/input_field_widget.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/state/sale_by_wallet_state.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AliasPayWidget extends StatelessWidget {
  final String Function(String)? globalTranslator;

  const AliasPayWidget({Key? key, this.globalTranslator}) : super(key: key);

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
          InputFieldWidget(
            widgetTitle: 'alis_tab'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            widgetHint: 'alias_name'.translate(
              context,
              globalTranslator: globalTranslator,
            ),
            onChange: (value) => walletCubit.aliasName = value,
            maxLength: 35,
            minLength: 3,
          ),
          BlocBuilder<SaleByWalletCubit, SaleByWalletState>(
              bloc: walletCubit,
              builder: (_, state) {
                if (walletCubit.state.verified) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.done,
                          color: successColor,
                        ),
                        Text(
                          'AZE#####AFIQ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ],
      ),
    );
  }
}
