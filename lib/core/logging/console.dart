// A logging integration that logs messages to console using standard print() function

import 'package:jklist/core/logging/logger.dart';
import 'package:jklist/core/logging/logging_level.dart';

class ConsoleLoggingIntegration implements LoggingIntegration {
  const ConsoleLoggingIntegration();

  @override
  void log(String message, LoggingLevel level) {
    print(message);
  }
}