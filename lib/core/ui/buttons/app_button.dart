import 'package:amwal_pay_sdk/core/resources/color/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends ElevatedButton {
  final bool isSmall;
  const AppButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget? child,
  })  : isSmall = false,
        super(
          key: key,
          onPressed: onPressed,
          child: child,
        );
  const AppButton.small({
    Key? key,
    required VoidCallback? onPressed,
    required Widget? child,
  })  : isSmall = true,
        super(
          key: key,
          onPressed: onPressed,
          child: child,
        );
  @override
  ButtonStyle? get style => ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryColor,
        fixedSize: Size(
          isSmall ? 150 : 350,
          55,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
          side: const BorderSide(color: lightGreyColor),
        ),
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 16 : 20,
        ),
      );
}

class AppOutlineButton extends OutlinedButton {
  final String title;
  AppOutlineButton({
    Key? key,
    required VoidCallback? onPressed,
    required this.title,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              color: darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

  @override
  ButtonStyle? get style => OutlinedButton.styleFrom(
        fixedSize: const Size(
          350,
          55,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      );
}
