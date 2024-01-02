import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_widget.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    Key? key,
    required this.widgetTitle,
    required this.widgetHint,
    required this.globalTranslator,
    required this.focusNode,
    this.initialValue,
    this.onChange,
  }) : super(key: key);

  final String widgetTitle;
  final String widgetHint;
  final FocusNode focusNode;
  final String? initialValue;
  final String Function(String)? globalTranslator;
  final void Function(String)? onChange;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      widget.onChange?.call(_textEditingController.text);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PhoneInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _textEditingController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return SizedBox(
      width: mediaQuerySize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.widgetTitle,
            style: const TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    'https://cdn.britannica.com/73/5773-004-F7C13E3D/Flag-Oman.jpg',
                    width: 20,
                    height: 12,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropDownListWidget<String>(
                    name: '',
                    hintText: '+968',
                    cubit: DropDownListCubit(),
                    onDone: () {},
                    nameMapper: (item) {
                      return item!;
                    },
                    onSelected: (item) {},
                    dropDownListItems: const [
                      "+20",
                      "+968",
                      "+967",
                      "+965",
                      "+961",
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    focusNode: widget.focusNode,
                    controller: _textEditingController,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: widget.widgetHint,
                      hintStyle: const TextStyle(
                        color: lightGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: FormBuilderValidators.compose(
                      [
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.match(
                            r'^((\+|00)?968)?[279]\d{7}$',
                            errorText: 'invalid_phone_number'.translate(
                              context,
                              globalTranslator: widget.globalTranslator,
                            )),
                        FormBuilderValidators.minLength(
                          7,
                          errorText: "invalid_phone_number".translate(
                            context,
                            globalTranslator: widget.globalTranslator,
                          ),
                        ),
                        FormBuilderValidators.maxLength(
                          15,
                          errorText: "invalid_phone_number".translate(
                            context,
                            globalTranslator: widget.globalTranslator,
                          ),
                        ),
                        FormBuilderValidators.required(
                          errorText: 'required_field'.translate(
                            context,
                            globalTranslator: widget.globalTranslator,
                          ),
                        ),
                      ],
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        11,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
