import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final void Function() resetState;
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.resetState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        ElevatedButton(
          onPressed: resetState,
          child: const Text('close'),
        ),
      ],
    );
  }
}
