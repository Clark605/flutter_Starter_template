# Agent Guidelines & Engineering Standards

## 1. Project Overview
`flutter_starter` is a production-grade, reusable Flutter starter template targeting Android, iOS, and Web. Built with Dart 3.11+ and Flutter 3.41+, it employs `flutter_bloc` (Bloc & Cubit), Freezed 3, Injectable DI, Dio networking with resilient guarded actions, Material 3 theming with full English and Arabic (RTL) localization, and native multi-flavor environments (`dev`, `staging`, `prod`).

## 2. Architecture & The 8 Golden Rules
Every feature lives in `lib/features/<feature_name>/`:
```
lib/features/<feature_name>/
├── data/
│   ├── models/          # Freezed + json_serializable DTOs (*.freezed.dart, *.g.dart)
│   ├── datasources/     # <feature>_remote_data_source.dart (abstract + impl)
│   └── repositories/    # i_<feature>_repository.dart (interface) + <feature>_repository_impl.dart
├── cubit/               # or bloc/: <feature>_cubit.dart + <feature>_state.dart (Freezed)
└── ui/
    ├── <feature>_screen.dart
    └── widgets/         # Widgets private to this feature
```

### The 8 Rules:
1. **No domain layer:** Cubits/Blocs depend on the repository interface (`data/repositories/i_*`), never on the implementation or a data source.
2. **Result types:** Repositories return `Result<T>`. Data sources throw; the repository converts errors to `Failure`. UI never sees Dio/Firebase/Supabase/GraphQL types.
3. **Freezed unions & ActionGuard:** State classes are Freezed unions. Cubits/Blocs use `ActionGuard` mixin for every async operation.
4. **Registration:** Repository impls use `@LazySingleton(as: I<Feature>Repository)`. Cubits/Blocs use `@injectable`. Run codegen after changes.
5. **Zero cross-feature imports:** Features never import other features. Code needed by 2+ features moves to `lib/core/` immediately.
6. **Thin screens:** Screens read state, call Cubit methods, and render. No business logic, no direct repository calls.
7. **L10n & Central routing:** All user-facing strings go through `l10n` (en + ar). All routes are added to `route_names.dart` and `app_router.dart`.
8. **Design tokens:** UI strictly follows mobile-first rules and theme tokens (no hardcoded colors, sizes, or text styles).

## 3. Directory Map (`lib/core/`)
- `config/`: Compile-time environment settings (`AppConfig`).
- `constants/`: Global constants (`StorageKeys`, `ApiConstants`).
- `di/`: Dependency injection setup (`injection.dart`).
- `errors/`: Error hierarchy (`AppException`, `Failure`, `Result<T>`, `ErrorMapper`).
- `network/`: Dio client, interceptors (`auth`, `retry`, `logging`), and `TokenProvider`.
- `observability/`: Crash reporting, analytics, remote config interfaces & `ForceUpdateGate`.
- `routes/`: Routing infrastructure (`AppRouter`, `AppNavigator`, `RouteNames`, `RouteProviders`).
- `services/`: Platform utilities (`ConnectivityService`).
- `storage/`: `PrefsService`, `SecureStorageService`.
- `theme/`: Theme tokens (`AppSpacing`, `AppRadius`, `AppColors`, `AppTypography`, `Breakpoints`).
- `utils/`: `AppLogger`, `ResponsiveLayout`, `PaginationState`, `FormValidators`.
- `widgets/`: Shared design system widgets (`AppButton`, `AppTextField`, `AppAvatar`, `StatusBadge`).

## 4. Mandatory New-Feature Checklist
1. Create the feature directory structure as shown in Section 2.
2. Model (Freezed) $\to$ Data Source $\to$ Repository Interface $\to$ Repository Impl.
3. State (Freezed union) $\to$ Cubit/Bloc extending `BaseCubit` or using `ActionGuard`.
4. Screen and private widgets using `lib/core/widgets/` and theme tokens.
5. Add localized strings in `l10n/app_en.arb` and `l10n/app_ar.arb`.
6. Add route name in `route_names.dart`, provider in `route_providers.dart`, and route in `app_router.dart`.
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
- Model: `features/example/data/models/item_dto.dart`
- Data Source: `features/example/data/datasources/item_remote_data_source.dart`
- Repository: `features/example/data/repositories/i_item_repository.dart`
- Cubit: `features/example/cubit/example_cubit.dart`
- Bloc: `features/example/bloc/example_detail_bloc.dart`
- UI: `features/example/ui/example_screen.dart`

## 6. Naming Conventions
- **Files:** `snake_case.dart` (e.g., `item_repository_impl.dart`).
- **Classes:** `PascalCase` (e.g., `ItemRepositoryImpl`).
- **Interfaces:** Prefix with `I` (e.g., `IItemRepository`).
- **States:** Freezed unions (e.g., `ExampleState.initial()`, `ExampleState.loaded()`).
- **Routes:** `RouteNames.exampleDetail = '/example-detail'`.
- **L10n keys:** `camelCase` (e.g., `exampleTitle`, `errorNetwork`).

## 7. Do / Don't Rules
- ❌ **DON'T** import another feature from `lib/features/<feature>/`.
- ❌ **DON'T** import `_impl.dart` or `datasources/` in Cubits/Blocs.
- ❌ **DON'T** call `print()`. Use `AppLogger.debug/info/warning/error`.
- ❌ **DON'T** hardcode user strings, colors, or raw paddings.
- ❌ **DON'T** use raw `try/catch` in Cubit/Bloc. Use `guard()`.
- ❌ **DON'T** emit after close. `BaseCubit` and `ActionGuard` handle this.
- ✅ **DO** return `Result<T>` from repositories.
- ✅ **DO** ensure touch targets $\ge$ 48px.
- ✅ **DO** test both English and Arabic RTL layouts.

## 8. Mobile-First UI Rules
- Touch targets must be $\ge$ 48px in height/width (`AppSpacing.minTouchTarget`).
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
