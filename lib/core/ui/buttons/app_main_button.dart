import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppMainButton extends StatelessWidget {
  const AppMainButton(
      {Key? key,
      required this.buttonIcon,
      required this.buttonText,
      required this.onClicked})
      : super(key: key);

  final String buttonIcon;
  final String buttonText;
  final void Function() onClicked;

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return SizedBox(
      width: mediaQuerySize.width,
      height: 65,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            side: const BorderSide(color: lightGreyColor),
          ),
        ),
        onPressed: onClicked,
        icon: SvgPicture.asset(buttonIcon),
        label: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
