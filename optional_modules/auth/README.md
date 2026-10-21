# Auth Optional Module

Production-ready authentication integration featuring single in-flight token refresh mutex, secure token persistence, biometric unlocking, and social authentication adapters.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  local_auth: ^2.3.0 # For biometric security (optional)
```

*(Note: `flutter_secure_storage` and `dio` are already in the base template).*

## 2. Included Files

- `auth_token_provider.dart`: Implements `TokenProvider` using `SecureStorageService`.
- `refresh_token_interceptor.dart`: Dio interceptor with concurrency queue that locks all requests while a single refresh operation executes, then replays queued requests with the refreshed token.
- `biometric_auth_service.dart`: Biometric authentication (FaceID, TouchID, Android Biometrics).

## 3. Wiring Steps

1. Copy `auth_token_provider.dart` into `lib/core/network/`.
2. Replace `@LazySingleton(as: TokenProvider)` on `NoOpTokenProvider` with `AuthTokenProvider`.
3. In `lib/core/network/dio_client.dart`, attach `RefreshTokenInterceptor`:
   ```dart
   dio.interceptors.insert(0, refreshTokenInterceptor);
   ```
4. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## 4. Google & GitHub Sign-In Notes

- For Google sign-in on Android, add your SHA-1 / SHA-256 fingerprint in the Google Cloud Console / Firebase Console and update `google_sign_in: ^6.2.2`.
- For GitHub sign-in, use OAuth with `flutter_web_auth_2` to open `https://github.com/login/oauth/authorize` and capture the callback redirect scheme (e.g. `starter://oauth-callback`).
