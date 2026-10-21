# Deep Links Optional Module

Deep linking and Universal Link routing supporting standard URLs (`https://example.com/item/123`) and custom scheme URIs (`starter://item/123`).

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  app_links: ^6.3.2
```

## 2. Platform Setup

- **Android**: Add `assetlinks.json` under `https://yourdomain/.well-known/assetlinks.json` and intent filters in `android/app/src/main/AndroidManifest.xml`.
- **iOS**: Add `apple-app-site-association` under `https://yourdomain/.well-known/apple-app-site-association` and configure Associated Domains in Xcode (`applinks:yourdomain`).

## 3. Wiring Steps

1. Copy `deep_link_service.dart` into `lib/core/services/`.
2. In `lib/bootstrap.dart`, start listening:
   ```dart
   final deepLinkService = getIt<DeepLinkService>();
   await deepLinkService.init();
   ```
