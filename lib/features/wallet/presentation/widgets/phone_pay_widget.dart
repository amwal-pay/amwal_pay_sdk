import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/inputfields/phone_input_field.dart';
import 'package:amwal_pay_sdk/features/wallet/cubit/sale_by_wallet_cubit.dart';
import 'package:amwal_pay_sdk/features/wallet/dependency/injector.dart';
import 'package:amwal_pay_sdk/features/wallet/state/sale_by_wallet_state.dart';

import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PhonePayWidget extends StatefulWidget {
  final String Function(String)? globalTranslator;

  const PhonePayWidget({Key? key, this.globalTranslator}) : super(key: key);

  @override
  State<PhonePayWidget> createState() => _PhonePayWidgetState();
}

class _PhonePayWidgetState extends State<PhonePayWidget> {
  late FocusNode _focusNode1;
  @override
  void initState() {
    super.initState();
    _focusNode1 = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final walletCubit = WalletInjector.instance.get<SaleByWalletCubit>();
    final size = MediaQuery.sizeOf(context);
    return Container(
      constraints: BoxConstraints.loose(Size(
        size.width,
        180,
      )),
      child: KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
          actions: [
            KeyboardActionsItem(
              focusNode: _focusNode1,
              displayArrows: false,
            ),
          ],
        ),
        child: FormBuilder(
          key: walletCubit.formKey,
          child: Column(
            children: [
              Text(
                'transaction_by_label'.translate(
                  context,
                  globalTranslator: widget.globalTranslator,
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
              BlocBuilder<SaleByWalletCubit, SaleByWalletState>(
                  bloc: walletCubit,
                  builder: (_, state) {
                    return PhoneInputField(
                      focusNode: _focusNode1,
                      globalTranslator: widget.globalTranslator,
                      initialValue: walletCubit.phoneNumber,
                      widgetTitle: 'wallet_mobile_number'.translate(
                        context,
                        globalTranslator: widget.globalTranslator,
                      ),
                      widgetHint: 'phone_number'.translate(
                        context,
                        globalTranslator: widget.globalTranslator,
                      ),
                      onChange: (value) => walletCubit.phoneNumber = value,
                    );
                  }),
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
        ),
      ),
    );
  }
}
