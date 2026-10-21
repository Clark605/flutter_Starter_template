# Firebase Observability Optional Module

Plugs directly into the core observability interfaces (`ICrashReporter`, `IAnalyticsService`, `IRemoteConfigService`) without modifying application code.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  firebase_core: ^3.12.1
  firebase_crashlytics: ^4.3.4
  firebase_analytics: ^11.4.4
  firebase_remote_config: ^5.3.4
```

## 2. Platform Setup

- Download `google-services.json` into `android/app/`.
- Download `GoogleService-Info.plist` into `ios/Runner/`.
- In `lib/bootstrap.dart`, run:
  ```dart
  await Firebase.initializeApp();
  ```

## 3. Wiring Steps

Replace the `@LazySingleton` annotations:
- In `firebase_crash_reporter.dart`: `@LazySingleton(as: ICrashReporter)`
- In `firebase_analytics_service.dart`: `@LazySingleton(as: IAnalyticsService)`
- In `firebase_remote_config_service.dart`: `@LazySingleton(as: IRemoteConfigService)`

Remove or comment out the `@LazySingleton` annotations on the `NoOp*` classes in `lib/core/observability/`.
Then run:
```bash
dart run build_runner build --delete-conflicting-outputs
```
