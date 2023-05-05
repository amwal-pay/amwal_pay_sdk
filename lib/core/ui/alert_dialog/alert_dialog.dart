import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionButtonText;
  final void Function() actionButtonFn;
  final Color actionButtonColor;
  final String Function(String)? globalTranslator;
  const AppAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actionButtonText,
    required this.actionButtonFn,
    required this.actionButtonColor,
    this.globalTranslator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          title.translate(
            context,
            globalTranslator: globalTranslator,
          ),
          style: const TextStyle(
            color: darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
      content: SizedBox(
        width: 330,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                content.translate(
                  context,
                  globalTranslator: globalTranslator,
                ),
                style: const TextStyle(
                  color: greyColor,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        SizedBox(
          height: 60,
          width: 135,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: greyColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                side: const BorderSide(
                  color: lightGreyColor,
                ),
              ),
            ),
            onPressed: Navigator.of(context).pop,
            child: Text(
              'cancel'.translate(
                context,
                globalTranslator: globalTranslator,
              ),
              style: const TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          width: 135,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: actionButtonColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8,
                ),
              ),
            ),
            onPressed: actionButtonFn,
            child: Text(
              actionButtonText.translate(
                context,
                globalTranslator: globalTranslator,
              ),
              style: const TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
