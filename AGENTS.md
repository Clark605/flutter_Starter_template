# Agent Guidelines & Engineering Standards

## 1. Project Overview
`flutter_starter` is a production-grade, reusable Flutter starter template targeting Android and iOS (Web optional). Built with Dart 3.11+ and Flutter 3.41.1, it employs `flutter_bloc` (Bloc & Cubit), Freezed 3, Injectable DI, Dio networking with resilient guarded actions, Material 3 theming with full English and Arabic (RTL) localization, and native multi-flavor environments (`dev`, `staging`, `prod`).

## 2. Architecture & The 8 Golden Rules
Every feature lives in `lib/features/<feature_name>/`:
```
lib/features/<feature_name>/
├── data/
│   ├── models/          # Freezed + json_serializable models (*.freezed.dart, *.g.dart)
│   ├── datasources/     # <feature>_remote_data_source.dart (abstract + impl)
│   └── repositories/    # <feature>_repository.dart (interface) + <feature>_repository_impl.dart
├── cubit/               # or bloc/: <feature>_cubit.dart + <feature>_state.dart (Freezed)
└── ui/
    ├── <feature>_screen.dart
    └── widgets/         # Widgets private to this feature
```

### The 8 Rules:
1. **No domain layer:** Cubits/Blocs depend on the repository interface (`data/repositories/<feature>_repository.dart`), never on the implementation or a data source.
2. **Result types & backend-agnostic:** Repositories return plain `Future<T>`. Data sources and repositories throw; `guard()` in Cubit/Bloc is the only place errors become `Failure` / `Result<T>`. UI never sees transport packages (Dio, Firebase, Supabase, GraphQL). `ErrorMapper` uses pluggable mappers registered via `ErrorMapper.register()`.
3. **Freezed unions & ActionGuard:** State classes are Freezed unions. Cubits/Blocs use `ActionGuard` for every async operation, supporting duplicate key rejection. For cancelling HTTP requests, pass Dio's `CancelToken` to the data source. `ActionGuard` does not access the service locator directly.
4. **Registration:** Repository impls use `@LazySingleton(as: <Feature>Repository)`. Cubits/Blocs use `@injectable`. Run codegen after changes.
5. **Zero cross-feature imports:** Features never import other features. `lib/core/` never imports `lib/features/` (except the central `lib/core/routes/route_providers.dart` assembly root). Code needed by 2+ features moves to `lib/core/` immediately.
6. **Thin screens:** Screens only read state, call Cubit methods, and render. UI files never import repository interfaces, repository implementations, or `core/di/injection.dart`.
7. **L10n & Central routing:** All user-facing strings go through `l10n` (en + ar). Routes are declared in `RouteNames` and `AppRouter`. Navigation redirects are enforced via pluggable `AuthRedirect` (`AppRouter.authRedirect`). Invalid/missing route arguments route to 404 (`buildNotFoundRoute`).
8. **Design tokens & logging:** UI strictly follows mobile-first rules and theme tokens (no hardcoded colors, sizes, or text styles). No raw `print()` calls in app code; use `AppLogger`.

## 3. Directory Map (`lib/core/`)
- `config/`: Compile-time environment settings (`AppConfig`).
- `constants/`: Global constants (`StorageKeys`, `ApiConstants`).
- `di/`: Dependency injection setup (`injection.dart`).
- `errors/`: Error hierarchy (`AppException`, `Failure`, `Result<T>`, pluggable `ErrorMapper`).
- `network/`: Dio client, interceptors (`auth`, `retry`, `logging`), `dio_error_mapper`, and `TokenProvider`.
- `observability/`: Crash reporting, analytics, remote config interfaces & `ForceUpdateGate`.
- `routes/`: Routing infrastructure (`AppRouter`, `AppNavigator`, `RouteNames`, `RouteProviders`).
- `services/`: Platform utilities (`ConnectivityService`).
- `storage/`: `PrefsService`, `SecureStorageService`.
- `theme/`: Theme tokens (`AppSpacing`, `AppRadius`, `AppColors`, `AppTypography`, `Breakpoints`).
- `utils/`: `AppLogger`, `ResponsiveLayout`, `PaginationState`, `FormValidators`.
- `widgets/`: Shared design system widgets (`AppButton`, `AppTextField`, `AppAvatar`, `StatusBadge`).

## 4. Mandatory New-Feature Checklist
1. Create the feature directory structure as shown in Section 2.
2. Model (Freezed) -> Data Source (throws) -> Repository Interface -> Repository Impl (throws).
3. State (Freezed union) -> Cubit/Bloc extending `BaseCubit` or using `ActionGuard` (`guard()` returns `Result<T>`).
4. Screen and private widgets using `lib/core/widgets/` and theme tokens. Screens consume Cubit via context.
5. Add localized strings in `l10n/app_en.arb` and `l10n/app_ar.arb`.
6. Add route name in `route_names.dart`, typed args in `ui/`, provider in `route_providers.dart`, and route in `app_router.dart`.
7. Run validation pipeline:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   dart format .
   flutter analyze
   dart run tool/check_architecture.dart
   ```
8. Verify layout at mobile width (<768px) and in RTL (Arabic).

## 5. Reference Implementation
Always inspect and mirror `lib/features/example/`:
- Model: `features/example/data/models/item_model.dart`
- Data Source: `features/example/data/datasources/item_remote_data_source.dart`
- Repository: `features/example/data/repositories/item_repository.dart`
- Cubit: `features/example/cubit/example_cubit.dart`
- Bloc: `features/example/bloc/example_detail_bloc.dart`
- UI: `features/example/ui/example_screen.dart`
- Args: `features/example/ui/example_detail_args.dart`

## 6. Naming Conventions
- **Files:** `snake_case.dart` (e.g., `item_repository_impl.dart`).
- **Classes:** `PascalCase` (e.g., `ItemRepositoryImpl`).
- **Interfaces:** Standard Flutter naming without `I` prefix; the implementation class appends `Impl` (e.g., `ItemRepository` interface, `ItemRepositoryImpl` implementation; `ItemRemoteDataSource` interface, `ItemRemoteDataSourceImpl` implementation).
- **Models:** Suffix with `_model.dart` and class name `*Model` (e.g., `item_model.dart`, `ItemModel`).
- **States:** Freezed unions (e.g., `ExampleState.initial()`, `ExampleState.loaded()`).
- **Routes:** `RouteNames.exampleDetail = '/example-detail'`.
- **L10n keys:** `camelCase` (e.g., `exampleTitle`, `errorNetwork`).

## 7. Do / Don't Rules
- ❌ **DON'T** import another feature from `lib/features/<feature>/`.
- ❌ **DON'T** import `lib/features/**` from `lib/core/**` (except `route_providers.dart`).
- ❌ **DON'T** import `_impl.dart`, `datasources/`, or `repositories/` in UI.
- ❌ **DON'T** import `core/di/injection.dart` in UI.
- ❌ **DON'T** call `print()`. Use `AppLogger.debug/info/warning/error`.
- ❌ **DON'T** hardcode user strings, colors, or raw paddings.
- ❌ **DON'T** use raw `try/catch` in Cubit/Bloc. Use `guard()`.
- ❌ **DON'T** emit after close. `BaseCubit` and `ActionGuard` handle this.
- ✅ **DO** return plain `Future<T>` from repositories; data sources and repositories throw, and `guard()` in Cubit/Bloc returns `Result<T>`.
- ✅ **DO** ensure touch targets >= 48px.
- ✅ **DO** test both English and Arabic RTL layouts.
- ✅ **DO** use `// architecture-ignore: <rule> <reason>` for documented exceptions.

## 8. Mobile-First UI Rules
- Touch targets must be >= 48px in height/width (`AppSpacing.minTouchTarget`).
- Page margins: 16px (`AppSpacing.lg` / `AppSpacing.edgeInsetsPage`).
- Use modal bottom sheets for mobile actions and pickers.
- Wrap pages in `SafeArea`.
- Always verify keyboard handling (`viewInsetsOf(context).bottom`).

## 9. Essential Commands
```bash
# Setup local environment files from templates
dart run tool/setup_env.dart

# Code generation
dart run build_runner build --delete-conflicting-outputs

# Format and analysis (must be 0 issues)
dart format .
flutter analyze

# Architecture validation
dart run tool/check_architecture.dart
dart run tool/check_architecture.dart --list-rules

# Launcher icons per flavor
dart run flutter_launcher_icons -f flutter_launcher_icons-dev.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-staging.yaml
dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml

# Run per flavor
flutter run --flavor dev --dart-define-from-file=env/dev.json
flutter run --flavor staging --dart-define-from-file=env/staging.json
flutter run --flavor prod --dart-define-from-file=env/prod.json

# Rename template
dart run tool/rename.dart --name my_app --org com.mycompany --display "My App"
```

## 10. Git Workflow
- Branches: `feat/<name>`, `fix/<name>`, `refactor/<name>`.
- Conventional Commits: `feat(items): add pagination support`, `fix(auth): handle token refresh lock`.

## 11. Definition of Done
A task is done only when:
1. `flutter analyze` reports 0 issues.
2. `dart format --set-exit-if-changed .` passes cleanly.
3. `dart run tool/check_architecture.dart` passes with 0 violations.
4. Codegen is executed and committed.
5. All user strings exist in both `app_en.arb` and `app_ar.arb`.
6. Verified at mobile width (<768px) and in RTL.
