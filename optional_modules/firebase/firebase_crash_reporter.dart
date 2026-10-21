// Copy to lib/core/observability/firebase_crash_reporter.dart when firebase_crashlytics is added.
/*
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/core/observability/crash_reporter.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ICrashReporter)
class FirebaseCrashReporter implements ICrashReporter {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> init() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  @override
  Future<void> setUserId(String? userId) async {
    await _crashlytics.setUserIdentifier(userId ?? '');
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}
*/
