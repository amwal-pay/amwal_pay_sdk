import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:amwal_pay_sdk/navigator/sdk_navigator.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final void Function() resetState;
  final Locale locale;
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.resetState,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String failedMessage = 'Failed';
    String closeTitle = 'Close';
    if (locale.languageCode == 'ar') {
      failedMessage = 'فشل';
      closeTitle = 'إغلاق';
    }
    return AlertDialog(
      title: Center(
        child: Text('failed'.translate(context)),
      ),
      content: Text(
        message.translate(
            AmwalSdkNavigator.amwalNavigatorObserver.navigator!.context),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        ElevatedButton(
          onPressed: resetState,
          child: Text('close'.translate(context)),
        ),
      ],
    );
  }
}
