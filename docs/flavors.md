# Flavors & Environment Configuration

`flutter_starter` provides native multi-flavor builds (`dev`, `staging`, `prod`) driven by `--dart-define-from-file=env/<flavor>.json`.

---

## 1. Environment Files

| Flavor | Target Application ID | App Name | Environment File |
|---|---|---|---|
| **Dev** | `com.starter.flutter_starter.dev` | Starter (Dev) | `env/dev.json` |
| **Staging** | `com.starter.flutter_starter.staging` | Starter (Staging) | `env/staging.json` |
| **Prod** | `com.starter.flutter_starter` | Starter | `env/prod.json` |

> [!IMPORTANT]
> Real environment files (`env/*.json`) are excluded in `.gitignore`. Example templates (`env/*.example.json`) are committed to version control.
> 
> To generate initial local environment files from the example templates:
> ```bash
> dart run tool/setup_env.dart
> ```

### CI/CD Secret Injection
In automated CI/CD pipelines (e.g., GitHub Actions), secrets should never be checked into version control. Instead, store your configuration as GitHub Actions Secrets (e.g. `PROD_ENV_JSON`) and write them to `env/<flavor>.json` during the workflow prior to building:
```yaml
- name: Inject Production Environment Secrets
  run: echo "${{ secrets.PROD_ENV_JSON }}" > env/prod.json
```
For default validation pipelines (CI), example files can be safely copied (`cp env/dev.example.json env/dev.json`).

### JSON Definition Example (`env/dev.json`):
```json
{
  "FLAVOR": "dev",
  "APP_NAME": "Starter (Dev)",
  "APPLICATION_ID": "com.starter.flutter_starter.dev",
  "BASE_URL": "https://jsonplaceholder.typicode.com",
  "CONNECT_TIMEOUT_SECONDS": 30,
  "RECEIVE_TIMEOUT_SECONDS": 30,
  "ENABLE_LOGGING": true,
  "MIN_SUPPORTED_VERSION": "1.0.0",
  "MAINTENANCE_MODE": false,
  "FORCE_UPDATE_URL": "https://example.com/update"
}
```

---

## 2. Running & Building per Flavor

### Development
```bash
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

### Staging
```bash
flutter run --flavor staging --dart-define-from-file=env/staging.json
```

### Production Release Build (Obfuscated)
```bash
flutter build apk \
  --flavor prod \
  -t lib/main.dart \
  --dart-define-from-file=env/prod.json \
  --obfuscate \
  --split-debug-info=build/symbols/android
```

---

## 3. Native Setup

### Android (`android/app/build.gradle.kts`)
Native product flavors match the `--flavor` flag:
```kotlin
flavorDimensions += "default"

productFlavors {
    create("dev") {
        dimension = "default"
        applicationIdSuffix = ".dev"
        manifestPlaceholders["appName"] = "Starter (Dev)"
    }
    create("staging") {
        dimension = "default"
        applicationIdSuffix = ".staging"
        manifestPlaceholders["appName"] = "Starter (Staging)"
    }
    create("prod") {
        dimension = "default"
        manifestPlaceholders["appName"] = "Starter"
    }
}
```

### iOS Schemes & Configurations
The project contains pre-configured Xcode schemes and build configurations for each flavor:
- Schemes (`ios/Runner.xcodeproj/xcshareddata/xcschemes/`): `dev`, `staging`, `prod`.
- Build Configurations: `Debug-dev`, `Release-dev`, `Profile-dev`, `Debug-staging`, `Release-staging`, `Profile-staging`, `Debug-prod`, `Release-prod`, `Profile-prod`.
- Configuration Files (`ios/Flutter/`): `dev.xcconfig`, `staging.xcconfig`, `prod.xcconfig` setting `PRODUCT_BUNDLE_IDENTIFIER` and `APP_DISPLAY_NAME`.
- Target Display Name: `Info.plist` references `$(APP_DISPLAY_NAME)` dynamically.

> [!NOTE]
> **Status:** iOS flavors are configured and committed, but marked **unverified on device** because the development workspace is running on Windows (no macOS/Xcode toolchain available).
>
> On a macOS machine, verify the iOS build with:
> ```bash
> flutter build ios --flavor dev --no-codesign -t lib/main.dart --dart-define-from-file=env/dev.json
> ```

---

## 4. Flavor-Specific App Icons

Each flavor uses dedicated assets and configuration files in the root directory:
- `dev`: `flutter_launcher_icons-dev.yaml` (`assets/images/app_logo_dev.png` with gold/amber ribbon)
- `staging`: `flutter_launcher_icons-staging.yaml` (`assets/images/app_logo_staging.png` with cyan ribbon)
- `prod`: `flutter_launcher_icons-prod.yaml` (`assets/images/app_logo.png` neutral base)

To regenerate icons after updating logos:
```bash
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-staging.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml
```

---

## 5. Release Signing
For production signing keys, keystore generation, and CI/CD secret configuration, see [`docs/releasing.md`](releasing.md).
