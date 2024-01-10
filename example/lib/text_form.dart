import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextForm extends StatelessWidget {
  final String title;
  final String? initialValue;
  final TextEditingController controller;
  final bool isNumeric;
  final int? maxLength;
  const TextForm({
    Key? key,
    required this.title,
    this.initialValue,
    required this.controller,
    this.isNumeric = false,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          maxLength: maxLength,
          keyboardType: isNumeric ? TextInputType.number : null,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Required Field';
            } else {
              return null;
            }
          },
          inputFormatters: [
            if (isNumeric) FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
