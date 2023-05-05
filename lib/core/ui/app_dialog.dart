import 'package:amwal_pay_sdk/core/resources/assets/app_assets_paths.dart';
import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:amwal_pay_sdk/localization/locale_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDialog extends Dialog {
  final BuildContext context;
  final String dialogIcon;
  final String dialogTitle;
  final String dialogMsg;
  final void Function() onclick;
  final String buttonText;

  const AppDialog({
    required this.context,
    Key? key,
    required this.onclick,
    required this.dialogTitle,
    required this.dialogMsg,
    this.buttonText = 'submit',
    this.dialogIcon = AppAssets.successfullyIcon,
  }) : super(key: key);

  @override
  ShapeBorder? get shape => const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      );

  @override
  Widget? get child {
    final mediaQuerySize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      width: mediaQuerySize.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30),
          SvgPicture.asset(dialogIcon),
          const SizedBox(height: 20),
          Text(
            dialogTitle,
            style: const TextStyle(
              color: blackColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            dialogMsg,
            style: const TextStyle(
              color: lightGreyColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: mediaQuerySize.width * .7,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: onclick,
              child: Text(
                buttonText.translate(context),
                style: const TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
