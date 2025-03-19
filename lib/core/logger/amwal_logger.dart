import 'package:firebase_crashlytics/firebase_crashlytics.dart';

typedef AmwalLoggerFunction = void Function(
    dynamic error, StackTrace? stackTrace);

class AmwalLogger {
  static AmwalLoggerFunction _logger = (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  };

  static void setLogger(AmwalLoggerFunction logger) {
    _logger = logger;
  }

  static void logError(dynamic error, StackTrace? stackTrace) {
    _logger(error, stackTrace);
  }
}
