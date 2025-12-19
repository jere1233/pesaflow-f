// lib/core/utils/logger.dart

class Logger {
  const Logger();

  void info(String message) {
    // lightweight logger - replace with more advanced logger if needed
    // ignore: avoid_print
    print('[INFO] $message');
  }

  void error(String message) {
    // ignore: avoid_print
    print('[ERROR] $message');
  }

  void warning(String message) {
    // ignore: avoid_print
    print('[WARN] $message');
  }

  void debug(String message) {
    // ignore: avoid_print
    print('[DEBUG] $message');
  }
}
