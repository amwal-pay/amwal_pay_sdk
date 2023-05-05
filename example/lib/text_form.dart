import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final String title;
  final String? initialValue;
  final TextEditingController controller;
  const TextForm({
    Key? key,
    required this.title,
    this.initialValue,
    required this.controller,
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
