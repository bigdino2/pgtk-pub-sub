import 'dart:io';

import 'package:logging/logging.dart';

class LoggingService {
  LoggingService(String name) {
    _logger = Logger(name);
    _init();
  }

  late Logger _logger;

  bool get debugMode => _logger.level == Level.ALL;

  void _init() {
    hierarchicalLoggingEnabled = true;

    _logger.onRecord.listen((record) {
      late String level;

      switch (record.level) {
        case Level.FINE:
          level = 'DEBUG';
        case Level.INFO:
          level = 'INFO';
        case Level.WARNING:
          level = 'WARNING';
        case Level.SEVERE:
          level = 'ERROR';
        default:
          level = 'I';
      }

      print('$level:: ${record.message}');

      // Only not print errors and stack traces when in debug
      if (level == 'ERROR' && Platform.environment['DART_ENV'] == 'debug') {
        if (record.error != null) {
          print(record.error);
        }

        if (record.stackTrace != null) {
          print(record.stackTrace);
        }
      }
    });

    _logger.onLevelChanged.listen((level) {
      d('Debug mode enabled');
    });
  }

  void enableDebugMode() {
    _logger.level = Level.ALL;
  }

  /// Log a debug message.
  ///
  /// Debug messages are not logged by default.
  void d(String message) {
    _logger.fine(message);
  }

  /// Log an info message.
  void i(String message) {
    _logger.info(message);
  }

  /// Log a warning message.
  void w(String message) {
    _logger.warning(message);
  }

  /// Log an error message.
  ///
  /// Optionally, log the error and stack trace.
  void e(String? message, {Object? error, StackTrace? stackTrace}) {
    _logger.severe(message, error, stackTrace);
  }
}
