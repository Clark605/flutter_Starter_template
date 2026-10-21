import 'package:flutter_starter/core/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

abstract interface class ICrashReporter {
  Future<void> init();
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });
  Future<void> log(String message);
  Future<void> setUserId(String? userId);
  Future<void> setCustomKey(String key, Object value);
}

@LazySingleton(as: ICrashReporter)
class NoOpCrashReporter implements ICrashReporter {
  @override
  Future<void> init() async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    AppLogger.error(
      'CrashReporter: ${reason ?? error}',
      tag: 'CrashReporter',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  Future<void> log(String message) async {
    AppLogger.debug('CrashReporter log: $message', tag: 'CrashReporter');
  }

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setCustomKey(String key, Object value) async {}
}
