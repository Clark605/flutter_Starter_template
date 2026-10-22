# Changelog

All notable changes to the `flutter_starter` template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-10-21

### Added
- **Feature-First Architecture**: Strictly structured `lib/features/<name>/` with data (models, datasources, repository interface + implementation), cubit/bloc, and thin UI layers.
- **State Management**: `flutter_bloc` with single Freezed data classes and `LoadStatus` enum for load lifecycles, demonstrated in `ExampleCubit` and `ExampleDetailBloc`.
- **Resilient ActionGuard**:
  - Double-submit and re-entrant prevention using action keys.
  - For cancelling HTTP requests, pass Dio's `CancelToken` to the data source.
  - Exponential backoff retry for transient network/server failures.
  - Decoupled from direct service locator access via configurable `ActionGuardConfig.crashReporter`.
- **Pluggable Error Mapping**:
  - `ErrorMapper` with pluggable mapper registry (`ErrorMapper.register`).
  - Extracted `dio_error_mapper.dart` covering 400 (validation), 401 (unauthorized), 403 (forbidden), 404 (not found), 408 (timeout), 409 (conflict), 422 (unprocessable entity), 429 (retryable server), and 502/503/504 (retryable server) errors.
  - Web-safe conditional import socket error checker (`is_socket_error.dart`) avoiding raw `dart:io` in shared code.
- **Navigation & Routing**:
  - General purpose `AppRouter` with typed route arguments (`ExampleDetailArgs`).
  - Automatic fallback to `NotFoundScreen` (`buildNotFoundRoute`) for invalid or missing route arguments.
  - Pluggable `AuthRedirect` navigation guard function.
- **Theming & Localization**:
  - Material 3 design system with light and dark themes and complete token sets (`AppSpacing`, `AppRadius`, `AppDurations`, `Breakpoints`).
  - Font switching: Inter for English, IBM Plex Sans Arabic for Arabic.
  - Complete English and Arabic localizations with RTL layout safety.
- **Multi-Flavor Environments**:
  - Android flavors (`dev`, `staging`, `prod`) with per-flavor application IDs and names.
  - iOS flavored build configurations, schemes, and `.xcconfig` bundle identifiers.
  - Flavored app icons with dev (gold) and staging (cyan) environment ribbons.
  - Non-secret environment templates (`env/*.example.json`) and automated `tool/setup_env.dart`.
- **Release Readiness**:
  - Android release signing in `build.gradle.kts` via `key.properties` with fallback warnings for local builds and failure gates in CI.
  - Hardened GitHub Actions CI (`ci.yml`) and Release (`release.yml`) workflows with Gradle caching and codegen diff validation.
- **Architecture Validation**:
  - `tool/check_architecture.dart` enforcing the 8 Golden Rules, relative import resolution, and `--list-rules` documentation.
  - Inline bypass standard `// architecture-ignore: <rule> <reason>`.
- **Tooling**:
  - Automated project renamer (`tool/rename.dart`) updating bundle identifiers, display names, package folders, and imports.
