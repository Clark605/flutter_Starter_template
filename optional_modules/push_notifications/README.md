# Push Notifications Optional Module

Comprehensive push notifications integrating Firebase Cloud Messaging (FCM) and `flutter_local_notifications` for foreground banners.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  firebase_core: ^3.12.1
  firebase_messaging: ^15.2.4
  flutter_local_notifications: ^18.0.1
```

## 2. Wiring Steps

1. Configure Firebase native project files (`google-services.json` on Android, `GoogleService-Info.plist` on iOS).
2. Copy `push_notification_service.dart` into `lib/core/services/`.
3. In `lib/bootstrap.dart`, initialize the notification service after DI setup:
   ```dart
   final notificationService = getIt<PushNotificationService>();
   await notificationService.init();
   ```
4. Handle background messages with a top-level `@pragma('vm:entry-point')` function.
