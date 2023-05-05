import 'package:amwal_pay_sdk/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DirectionalWidget extends StatelessWidget {
  final Widget child;
  const DirectionalWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)?.locale ?? const Locale('en');
    final quarterTurns = locale.languageCode == "ar" ? 2 : 0;
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: child,
    );
  }
}
