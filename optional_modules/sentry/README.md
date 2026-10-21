# Sentry Crash Reporting Optional Module

Integrates Sentry crash and performance monitoring behind the `ICrashReporter` interface.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  sentry_flutter: ^9.1.0
```

## 2. Wiring Steps

1. In `lib/bootstrap.dart`, wrap `runApp` with `SentryFlutter.init(...)`.
2. Copy `sentry_crash_reporter.dart` into `lib/core/observability/`.
3. Annotate `SentryCrashReporter` with `@LazySingleton(as: ICrashReporter)` and remove the annotation from `NoOpCrashReporter`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
