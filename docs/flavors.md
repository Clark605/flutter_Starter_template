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

### iOS Schemes
Create Xcode Schemes corresponding to configurations (`Debug-dev`, `Release-prod`, etc.) matching the bundle identifiers.
