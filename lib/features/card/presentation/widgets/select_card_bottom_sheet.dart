import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/ui/buttons/app_button.dart';
import 'package:amwal_pay_sdk/core/ui/inputfields/input_field_widget.dart';
import 'package:amwal_pay_sdk/features/card/data/models/response/customer_token_response.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SelectCardBottomSheet extends StatefulWidget {
  final List<CustomerToken> tokens;
  final CustomerToken? initialValue;
  final void Function(CustomerToken?, String?) onConfirm;

  const SelectCardBottomSheet({
    super.key,
    required this.tokens,
    this.initialValue,
    required this.onConfirm,
  });

  @override
  State<SelectCardBottomSheet> createState() => _SelectCardBottomSheetState();
}

class _SelectCardBottomSheetState extends State<SelectCardBottomSheet> {
  CustomerToken? _selectedCustomerToken;
  String? _cvv;
  late FocusNode _cardFocusNode;


  KeyboardActionsConfig get _keyboardActionsConfig {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: const Color(0xFFCAD1D9), //Apple keyboard color
      actions: [
        KeyboardActionsItem(
          focusNode: _cardFocusNode,
          toolbarButtons: [
                (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                   "Done",
                    style: TextStyle(
                      color: Color(0xFF0978ED), //Done button color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _cardFocusNode = FocusNode();

    _selectedCustomerToken = widget.initialValue;
  }

  void _select(CustomerToken? token) {
    setState(() {
      _selectedCustomerToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      const SizedBox(height: 8),
      ...widget.tokens.map<Widget>((item) {
        return Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 5,
                  child: RadioListTile(
                    value: item.cardNumber,
                    groupValue: _selectedCustomerToken?.cardNumber,
                    onChanged: (_) => _select(item),
                    title: Text(item.cardNumber),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: KeyboardActions(
                      config: _keyboardActionsConfig,
                      disableScroll: true,

                      child: InputFieldWidget(
                        focusNode: _cardFocusNode,
                        key: const Key('ccv'),
                        widgetTitle: 'cvv',
                        widgetTitleIcon: AppAssets.cvvIcon,
                        widgetHint: 'digits'.translate(context),
                        maxLength: 3,
                        minLength: 3,
                        done: true,
                        hint: 'cvv_hint',
                        isNumber: true,
                        onChange: (value) {
                          _cvv = value;
                        },
                      )),
                ),
                // ),
              ],
            ),
            const Divider(
              thickness: 1,
              endIndent: 25,
              indent: 25,
            )
          ],
        );
      }),
      const Expanded(flex: 4, child: SizedBox()),
      AppButton(
        onPressed: () {
          widget.onConfirm(_selectedCustomerToken, _cvv);
          Navigator.of(context).pop();
        },
        child: Text(
          'confirm'.translate(context),
        ),
      ),
      const SizedBox(height: 8),
      AppButton(
        onPressed: () {
          widget.onConfirm(null, null);
          Navigator.of(context).pop();
        },
        child: Text(
          'add_new_card'.translate(context),
        ),
      ),
      const Expanded(child: SizedBox()),
    ]);
  }
}
