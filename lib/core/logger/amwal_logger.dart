
typedef AmwalLoggerFunction = void Function(
    dynamic error, StackTrace? stackTrace);

class AmwalLogger {
  static AmwalLoggerFunction _logger = (error, stackTrace) {

  };

  static void setLogger(AmwalLoggerFunction logger) {
    _logger = logger;
  }

  static void logError(dynamic error, StackTrace? stackTrace) {
    _logger(error, stackTrace);
  }
}
