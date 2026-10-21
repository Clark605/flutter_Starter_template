# Release & Signing Guide

This guide describes how to configure production signing and deploy release builds for Android and iOS using `flutter_starter`.

---

## 1. Android Release Signing

### Local Keystore Setup

1. **Generate an Upload Keystore:**
   ```bash
   keytool -genkey -v -keystore android/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias upload
   ```

2. **Create `android/key.properties`:**
   Copy `android/key.properties.example` to `android/key.properties` and fill in your credentials:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

> [!IMPORTANT]
> `android/key.properties` and `*.jks` are excluded in `.gitignore` and must never be committed to source control.
> If `android/key.properties` is missing during local builds, Gradle falls back to the debug signing config and displays a warning.

---

## 2. CI/CD Release Automation (GitHub Actions)

The release workflow (`.github/workflows/release.yml`) automatically signs Android artifacts and produces obfuscated production binaries when a release tag (e.g. `v1.0.0`) is pushed.

### Required GitHub Repository Secrets

Configure the following secrets in your repository settings (**Settings > Secrets and variables > Actions**):

| Secret Name | Description | Example |
|---|---|---|
| `ANDROID_KEYSTORE_BASE64` | Base64-encoded keystore file | `base64 -i android/upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | Password for the keystore | `mypassword123` |
| `ANDROID_KEY_ALIAS` | Alias of the release key | `upload` |
| `ANDROID_KEY_PASSWORD` | Password for the key alias | `mypassword123` |
| `PROD_ENV_JSON` *(Optional)* | Production environment file contents | `{"FLAVOR":"prod",...}` |

### Generating `ANDROID_KEYSTORE_BASE64`
Run the following command on your local machine to obtain the Base64 representation of your `.jks` file:
```bash
# macOS / Linux
base64 -i android/upload-keystore.jks

# Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/upload-keystore.jks"))
```
Copy the terminal output and paste it as the `ANDROID_KEYSTORE_BASE64` secret in GitHub.

---

## 3. Building Release Artifacts Locally

### Android App Bundle (AAB for Google Play):
```bash
flutter build appbundle \
  --flavor prod \
  -t lib/main.dart \
  --dart-define-from-file=env/prod.json \
  --obfuscate \
  --split-debug-info=build/symbols/android
```

### Android Split APKs:
```bash
flutter build apk \
  --flavor prod \
  --split-per-abi \
  -t lib/main.dart \
  --dart-define-from-file=env/prod.json \
  --obfuscate \
  --split-debug-info=build/symbols/android
```

### iOS Application (Release, No Codesign):
```bash
flutter build ios \
  --flavor prod \
  --no-codesign \
  -t lib/main.dart \
  --dart-define-from-file=env/prod.json \
  --obfuscate \
  --split-debug-info=build/symbols/ios
```
