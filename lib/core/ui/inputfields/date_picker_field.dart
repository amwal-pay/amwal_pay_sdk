import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({Key? key}) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _dateTextController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateTextController = TextEditingController();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_selectedDate != null) {
      _dateTextController.text =
          DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(
              days: 365 * 10,
            ),
          ),
        );
        setState(() => _selectedDate = selectedDate);
      },
      child: SizedBox(
        width: mediaQuerySize.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'expiration_label',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FormBuilderTextField(
              name: 'expiration_date',
              enabled: false,
              readOnly: true,
              controller: _dateTextController,
              maxLines: 1,
              validator:
                  FormBuilderValidators.required(errorText: "required_field"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'dd-MM-yyyy',
                focusColor: whiteColor,
                errorStyle: const TextStyle(
                  color: redColor,
                ),
                hintStyle: const TextStyle(
                  color: lightGreyColor,
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
