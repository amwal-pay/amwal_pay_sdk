import 'package:flutter/material.dart';

import 'app_localizations.dart';

extension LocalUtils on String {
  String translate(BuildContext context, {String Function(String p1)? globalTranslator}) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}
