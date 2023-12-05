import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_cubit.dart';
import 'package:amwal_pay_sdk/core/ui/listpicker/drop_down_list_widget.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    Key? key,
    required this.widgetTitle,
    required this.widgetHint,
    required this.globalTranslator,
    this.onChange,
  }) : super(key: key);

  final String widgetTitle;
  final String widgetHint;
  final String Function(String)? globalTranslator;
  final void Function(String)? onChange;
  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return SizedBox(
      width: mediaQuerySize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widgetTitle,
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
                    onChanged: onChange,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: widgetHint,
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
                              globalTranslator: globalTranslator,
                            )),
                        FormBuilderValidators.minLength(
                          7,
                          errorText: "invalid_phone_number".translate(
                            context,
                            globalTranslator: globalTranslator,
                          ),
                        ),
                        FormBuilderValidators.maxLength(
                          15,
                          errorText: "invalid_phone_number".translate(
                            context,
                            globalTranslator: globalTranslator,
                          ),
                        ),
                        FormBuilderValidators.required(
                          errorText: 'required_field'.translate(
                            context,
                            globalTranslator: globalTranslator,
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
