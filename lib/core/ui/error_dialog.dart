import 'package:amwal_pay_sdk/localization/locale_utils.dart';
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
      title: Center(child: Text("Failed".translate(context))),
      content: Text(
        message.translate(context),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        ElevatedButton(
          onPressed: resetState,
          child: Text("Close".translate(context)),
        ),
      ],
    );
  }
}
