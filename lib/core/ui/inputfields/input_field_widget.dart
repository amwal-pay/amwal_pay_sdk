import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// import 'package:get/get.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    Key? key,
    this.widgetTitle = '',
    this.widgetTitleIcon,
    required this.widgetHint,
    this.isRequired = true,
    this.isNumber = false,
    this.isEmail = false,
    this.isEnglish = false,
    this.maxLength = 20,
    this.minLength = 0,
    this.onChange,
    this.decoration,
  }) : super(key: key);

  final String widgetTitle;
  final String widgetHint;
  final String? widgetTitleIcon;
  final bool isRequired;
  final bool isEmail;
  final bool isNumber;
  final bool isEnglish;
  final int maxLength;
  final int minLength;
  final void Function(String)? onChange;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    InputDecoration? inputDecoration = decoration;
    inputDecoration ??= InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: widgetHint,
      focusColor: whiteColor,
      hintStyle: const TextStyle(
        color: lightGreyColor,
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return SizedBox(
      width: mediaQuerySize.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widgetTitle,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              if (widgetTitleIcon != null)
                SvgPicture.asset(widgetTitleIcon!,)
              else
                const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onChanged: onChange,
            validator: FormBuilderValidators.compose([
              if (isRequired)
                FormBuilderValidators.required(errorText: 'required_field'),
              if (isEmail)
                FormBuilderValidators.email(errorText: 'invalid_mail'),
              if (minLength != 0)
                FormBuilderValidators.minLength(minLength,
                    errorText: 'invalid_input_field'),
            ]),
            maxLines: 1,
            decoration: inputDecoration,
            textInputAction: TextInputAction.next,
            keyboardType: isNumber ? TextInputType.number : null,
            inputFormatters: [
              if (isNumber == true) FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(maxLength),
              if (isEnglish)
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]'))
            ],
          ),
        ],
      ),
    );
  }
}
