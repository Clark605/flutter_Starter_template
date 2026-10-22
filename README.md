# 🚀 Flutter Starter Template

[![Flutter](https://img.shields.io/badge/Flutter-3.41.1-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11.0-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI](https://github.com/Clark605/flutter_Starter_template/actions/workflows/ci.yml/badge.svg)](https://github.com/Clark605/flutter_Starter_template/actions/workflows/ci.yml)

A production-grade, reusable, backend-agnostic Flutter starter template. Built with **Bloc & Cubit**, **Freezed 3**, **Injectable DI**, **Dio** with resilient guarded actions, **Material 3** theming with full English and Arabic (RTL) support, and native multi-flavor environments.

Runs out of the box with **zero external accounts or configuration** (no Firebase/API keys required).

---

## 🏛️ Architecture Overview

The architecture enforces a strict **Feature-First Architecture with Repository Boundary** without an artificial domain layer. Presentation logic depends on repository interfaces returning a sealed `Result<T>`.

```mermaid
flowchart TD
    subgraph UI ["Presentation Layer"]
        Screen["FeatureScreen\n(Thin View)"]
        Widget["FeatureWidgets"]
        Screen --> Widget
    end

    subgraph State ["State Management"]
        Cubit["Cubit / Bloc\n(ActionGuard Mixin)"]
        State["FeatureState\n(Freezed Class + LoadStatus)"]
        Cubit --> State
    end

    subgraph Domain ["Repository boundary (interface in data/)"]
        RepoInterface["FeatureRepository\n(Returns Future<T>)"]
    end

    subgraph Data ["Data Layer"]
        RepoImpl["FeatureRepositoryImpl\n(@LazySingleton)"]
        RemoteSource["RemoteDataSource\n(Dio / Firebase / Supabase)"]
        DTO["DTO Models\n(Freezed + JSON)"]

        RepoImpl --> RemoteSource
        RemoteSource --> DTO
    end

    UI --> Cubit
    Cubit --> RepoInterface
    RepoInterface -.-> RepoImpl
```

---

## ✨ Features & Capabilities

- **State Management**: `flutter_bloc` with both **Cubit** and **Bloc** demonstrated and supported.
- **Guarded Actions (`ActionGuard`)**: Closed-state safety, re-entrant double-submit prevention, and pluggable error mapping. Repositories and data sources throw; `guard()` returns `Result<T>`. For cancelling HTTP requests, pass Dio's `CancelToken` to the data source. Decoupled from direct service locator access.
- **Errors & Results**: Sealed `Result<T>` (`Success`, `Error`) and typed `Failure` hierarchy (`network`, `timeout`, `unauthorized`, `forbidden`, `notFound`, `conflict`, `validation`, `server`, `cancelled`, `unknown`) carrying stable error codes and translation keys. Pluggable `ErrorMapper` registry.
- **Navigation & Guarding**: Central routing via `AppRouter` with typed route arguments (`ExampleDetailArgs`), invalid route fallback to 404 (`buildNotFoundRoute`), and pluggable `AuthRedirect` for route redirects.
- **Material 3 Theming**: Design tokens (`AppSpacing`, `AppRadius`, `AppDurations`, `Breakpoints`), dark/light themes, and locale-aware typography (Inter for English, IBM Plex Sans Arabic for Arabic).
- **Full Localization (en + ar)**: ARB-driven localizations with RTL layout safety.
- **Networking**: Dio module with timeouts, JSON headers, `AuthInterceptor` slot driven by `TokenProvider`, exponential retry interceptor, web-safe socket checks, and debug-only sanitized logging.
- **Connectivity & Offline**: `ConnectivityService`, `ConnectivityCubit`, animated offline banner, and no-internet screen.
- **Observability Contracts**: `ICrashReporter`, `IAnalyticsService`, and `IRemoteConfigService` with zero-config no-op defaults, plus `ForceUpdateGate`.
- **Reference Feature (`features/example`)**: Full reference implementation demonstrating the data -> repository -> Cubit/Bloc -> UI pattern with pagination and skeletonizer.
- **Automated Tooling**: Architecture linter (`tool/check_architecture.dart`), automated rename tool (`tool/rename.dart`), GitHub Actions CI/CD workflows, and lefthook pre-commit hooks.

---

## ⚡ Get Started in 5 Minutes

### 1. Clone or Use This Template
```bash
git clone https://github.com/Clark605/flutter_Starter_template.git my_app
cd my_app
```

### 2. Rename the Project
Run the idempotent rename script to set your app identifier, package name, and display title:
```bash
dart run tool/rename.dart --name my_app --org com.mycompany --display "My App"
```

### 3. Set Up Environment Configuration
Generate local environment files (`env/*.json`) from the committed non-secret templates:
```bash
dart run tool/setup_env.dart
```

### 4. Fetch Dependencies & Run Code Generation
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the Dev Flavor
```bash
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

---

## ⚠️ Known Limitations

- **Web Target**: Web is supported with web-safe conditional imports (no raw `dart:io` in shared logic), but full responsive web testing and production web bundling are optional. See [Web Support Guide](docs/architecture.md#web-support).
- **iOS Flavors**: Flavored iOS schemes and build configurations require macOS with Xcode installed. On Linux or Windows CI hosts, iOS builds cannot be compiled.
- **Release Signing**: Android release builds require configuring `android/key.properties` (see `android/key.properties.example`). Without valid release keys, local release builds fallback to debug signing and produce a warning, while CI release builds fail fast.
- **Minimum Android SDK**: Android `minSdk` is 24 to support secure cryptographic storage in `flutter_secure_storage` v11.

---

## 📦 Base Template vs. Optional Modules

The core repository contains only what every production app requires. Specialized integrations live in `optional_modules/` outside `lib/`:

| Component | Base Template | Optional Module |
|---|:---:|:---:|
| State Management (`flutter_bloc`) | ✅ | — |
| REST Client (`dio`) | ✅ | — |
| Storage (`shared_preferences`, `flutter_secure_storage`) | ✅ | — |
| Design Tokens & Theming | ✅ | — |
| English + Arabic Localization | ✅ | — |
| Architecture Linter & Rename Script | ✅ | — |
| Single In-Flight JWT Refresh Lock | — | `optional_modules/auth/` |
| Biometric Security (FaceID / Fingerprint) | — | `optional_modules/auth/` |
| Push Notifications (FCM + Local Alerts) | — | `optional_modules/push_notifications/` |
| Deep Links / Universal Links | — | `optional_modules/deep_links/` |
| Local Database (Drift SQLite Cache) | — | `optional_modules/local_db/` |
| Firebase (Crashlytics, Analytics, RemoteConfig) | — | `optional_modules/firebase/` |
| Sentry Crash Reporting | — | `optional_modules/sentry/` |
| SignalR Realtime Hub | — | `optional_modules/signalr/` |
| Cloud Firestore Backend | — | `optional_modules/backend_firebase/` |
| Supabase Backend | — | `optional_modules/backend_supabase/` |
| GraphQL Backend | — | `optional_modules/backend_graphql/` |

---

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── bootstrap.dart                 # Initialization, crash zones, DI & gate check
├── app.dart                       # MaterialApp, BlocProviders, Theme, L10n
├── l10n/                          # Generated localization delegates
├── core/
│   ├── config/                    # Compile-time defines (AppConfig)
│   ├── constants/                 # StorageKeys, ApiConstants
│   ├── cubit/                     # ActionGuard mixin, BaseCubit, AppSettingsCubit
│   ├── di/                        # GetIt and Injectable container
│   ├── errors/                    # AppException, Failure, Result<T>, ErrorMapper
│   ├── network/                   # DioClient, AuthInterceptor, RetryInterceptor, dio_error_mapper
│   ├── observability/             # CrashReporter, Analytics, RemoteConfig, ForceUpdateGate
│   ├── routes/                    # AppRouter, AppNavigator, RouteNames, RouteProviders
│   ├── services/                  # ConnectivityService
│   ├── storage/                   # PrefsService, SecureStorageService
│   ├── theme/                     # AppSpacing, AppRadius, AppColors, AppTypography
│   ├── utils/                     # AppLogger, ResponsiveLayout, PaginationState, Validators
│   └── widgets/                   # AppButton, AppTextField, AppAvatar, StatusBadge, etc.
└── features/
    └── example/                   # Complete reference feature implementation
        ├── data/
        │   ├── models/            # Freezed ItemModel
        │   ├── datasources/       # ItemRemoteDataSource & ItemRemoteDataSourceImpl
        │   └── repositories/      # ItemRepository & ItemRepositoryImpl
        ├── cubit/                 # ExampleCubit & ExampleState
        ├── bloc/                  # ExampleDetailBloc, Event & State
        └── ui/                    # ExampleScreen, ExampleDetailScreen, ExampleDetailArgs & ItemCard
```

---

## 📸 Screenshots

| Light Theme | Dark Theme | Arabic (RTL) |
|:---:|:---:|:---:|
| *(Screenshots placeholder)* | *(Screenshots placeholder)* | *(Screenshots placeholder)* |

---

## 📄 Documentation Index

- [Architecture Guide](docs/architecture.md)
- [Design Tokens & Theming](docs/theming.md)
- [Flavors & Environments](docs/flavors.md)
- [Release Guide](docs/releasing.md)
- [Backend Variants (REST / Firebase / Supabase / GraphQL)](docs/backend-variants.md)
- [Optional Modules Catalog](docs/optional-modules.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
- [AI Agent Guidelines](AGENTS.md)

---

## ⚖️ License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
