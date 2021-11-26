import 'package:logger/logger.dart';

mixin Log {
  static bool isEnabled = false;
  static final _logger = Logger();

  static void info(String? message) {
    if (!Log.isEnabled) return;
    _logger.i(message);
  }

  static void error(String? message) {
    if (!Log.isEnabled) return;
    _logger.e(message);
  }
}
