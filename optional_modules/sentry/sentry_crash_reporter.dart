// Copy to lib/core/observability/sentry_crash_reporter.dart when sentry_flutter is added.
/*
import 'package:flutter_starter/core/observability/crash_reporter.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

@LazySingleton(as: ICrashReporter)
class SentryCrashReporter implements ICrashReporter {
  @override
  Future<void> init() async {}

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      hint: Hint.withMap({'reason': reason ?? '', 'fatal': fatal}),
    );
  }

  @override
  Future<void> log(String message) async {
    await Sentry.addBreadcrumb(Breadcrumb(message: message));
  }

  @override
  Future<void> setUserId(String? userId) async {
    await Sentry.configureScope((scope) {
      scope.setUser(userId != null ? SentryUser(id: userId) : null);
    });
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    await Sentry.configureScope((scope) {
      scope.setExtra(key, value);
    });
  }
}
*/
