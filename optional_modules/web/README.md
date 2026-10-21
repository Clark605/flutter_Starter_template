# Web Deployment Optional Module

Guide for configuring and optimizing Flutter Web with path-based URLs (no `#`), responsive adaptations, and web server configuration.

## 1. Enabling Flutter Web

Flutter Web support is already created in the `web/` folder. To run the app on Web:

```bash
flutter run -d chrome --dart-define-from-file=env/dev.json
```

## 2. Path URL Strategy (Removing the `#` Hash)

By default, Flutter uses hash routing (`/#/settings`). To enable clean HTML5 URLs (`/settings`):

1. Add `flutter_web_plugins` (available in Flutter SDK).
2. In `lib/bootstrap.dart`, before `runApp`:
   ```dart
   import 'package:flutter_web_plugins/url_strategy.dart';
   
   void configureWebUrlStrategy() {
     usePathUrlStrategy();
   }
   ```
3. Use conditional imports to avoid importing web libraries on native platforms.

## 3. Shared Code Rules for Web Compatibility

- **Never import `dart:io` in shared code**. Use conditional imports or abstract interfaces (e.g. `PlatformDispatcher` or `defaultTargetPlatform` from `package:flutter/foundation.dart`).
- When uploading files on Web, use `dio.FormData.fromMap({'file': MultipartFile.fromBytes(bytes, filename: 'name')})` instead of `MultipartFile.fromFile(path)`.
- For cookies and CORS, configure server response headers (`Access-Control-Allow-Origin`, `Access-Control-Allow-Credentials`).
