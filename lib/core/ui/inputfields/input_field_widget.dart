import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class InputFieldWidget extends StatefulWidget {
  const InputFieldWidget({
    Key? key,
    this.widgetTitle = '',
    this.widgetTitleIcon,
    required this.widgetHint,
    this.isRequired = true,
    this.isNumber = false,
    this.isEmail = false,
    this.isEnglish = false,
    this.isMonth = false,
    this.isYear = false,
    this.maxLength = 20,
    this.minLength = 0,
    this.onChange,
    this.decoration,
    this.readOnly = false,
    this.initialValue,
    this.focusNode,
    this.hint = 'required_field',
    this.validators = const [],
  }) : super(key: key);

  final String hint;
  final String widgetTitle;
  final String widgetHint;
  final String? widgetTitleIcon;
  final bool isRequired;
  final bool isEmail;
  final bool isNumber;
  final bool isEnglish;
  final bool isMonth;
  final bool isYear;
  final int maxLength;
  final int minLength;
  final bool readOnly;
  final void Function(String)? onChange;
  final InputDecoration? decoration;
  final String? initialValue;
  final FocusNode? focusNode;
  final List<FormFieldValidator<String>> validators;

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
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
  void didUpdateWidget(covariant InputFieldWidget oldWidget) {
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
    InputDecoration? inputDecoration = widget.decoration;
    inputDecoration ??= InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: widget.widgetHint,
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

    // Combine default validators with the ones passed via constructor
    final validators = [
      if (widget.isRequired)
        FormBuilderValidators.required(
            errorText: widget.hint.translate(context)),
      if (widget.isEmail)
        FormBuilderValidators.email(
            errorText: 'invalid_mail'.translate(context)),
      if (widget.minLength != 0)
        FormBuilderValidators.minLength(widget.minLength,
            errorText: 'invalid_input_field'.translate(context)),
      if (widget.isMonth)
        FormBuilderValidators.max(12,
            errorText: 'invalid-month'.translate(context)),
      if (widget.isYear)
        FormBuilderValidators.min(
            int.parse(DateFormat('yy').format(DateTime.now())),
            errorText: 'invalid-month'.translate(context)),
      ...widget.validators
    ];

    return SizedBox(
      width: mediaQuerySize.width * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                child: Text(
                  widget.widgetTitle,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              if (widget.widgetTitleIcon != null)
                SvgPicture.asset(
                  widget.widgetTitleIcon!,
                  package: 'amwal_pay_sdk',
                  height: 16,
                )
              else
                const SizedBox(height: 16),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          TextFormField(
            focusNode: widget.focusNode,
            readOnly: widget.readOnly,
            controller: _textEditingController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: FormBuilderValidators.compose(validators),
            maxLines: 1,
            decoration: inputDecoration,
            textInputAction: TextInputAction.next,
            keyboardType: widget.isNumber ? TextInputType.number : null,
            inputFormatters: [
              if (widget.isNumber == true)
                FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.maxLength),
              if (widget.isEnglish)
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z\\s]'))
            ],
          ),
        ],
      ),
    );
  }
}
