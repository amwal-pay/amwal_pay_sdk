import 'package:amwal_pay_sdk/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DirectionalWidget extends StatelessWidget {
  final Widget child;
  final Locale locale;
  const DirectionalWidget({Key? key, required this.child, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(locale);
    print(locale.languageCode);
    final quarterTurns = locale.languageCode == "ar" ? 2 : 0;
    print(quarterTurns);
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: child,
    );
  }
}
