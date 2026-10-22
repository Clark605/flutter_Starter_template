# Contributing to `flutter_starter`

Thank you for contributing to the Flutter Starter Template! To maintain the highest quality and architectural consistency, please follow these guidelines.

---

## 1. Branch Naming Conventions

All branches should follow standard prefixes:
- `feat/<feature-name>`: A new feature, module, or core addition.
- `fix/<bug-name>`: A bug fix or defect correction.
- `refactor/<scope>`: Code changes that neither fix a bug nor add a feature.
- `docs/<scope>`: Documentation updates.
- `chore/<task>`: Tooling, dependency updates, or CI maintenance.

*Example:* `feat/action-token-cancellation`, `fix/ios-flavors-scheme`.

---

## 2. Commit Message Guidelines (Conventional Commits)

Commit messages must adhere to the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Types:
- `feat`: A new feature or capability.
- `fix`: A bug fix.
- `refactor`: Internal refactoring without behavioral alterations.
- `docs`: Documentation updates.
- `chore`: Build system, configuration, or dependency updates.
- `perf`: Performance optimizations.
- `test`: Adding or correcting tests.

### Examples:
- `feat(example): add item pagination support`
- `fix(network): map HTTP 409 to Failure.conflict`
- `docs(flavors): document Android release signing keys`

---

## 3. Architecture Rules & The 8 Golden Rules

Before modifying code, read [AGENTS.md](AGENTS.md) and [docs/architecture.md](docs/architecture.md). Every feature must adhere to the 8 Golden Rules:
1. **No Domain Layer:** Cubits/Blocs depend on repository interfaces (`data/repositories/<feature>_repository.dart`), never on datasources or concrete implementations.
2. **Result Types:** Data sources and repositories throw; `guard()` in Cubit/Bloc returns `Result<T>`. UI never sees transport packages (Dio, Firebase, Supabase, etc.).
3. **State Pattern & ActionGuard:** States are single Freezed classes with `LoadStatus status`, data fields, and `Failure? failure`. Async actions use `ActionGuard`.
4. **Registration:** Repositories use `@LazySingleton(as: <Feature>Repository)`. Cubits/Blocs use `@injectable`.
5. **Zero Cross-Feature Imports:** Features cannot import other features. `lib/core/` cannot import `lib/features/` (except the central `route_providers.dart`).
6. **Thin Screens:** Screens only read state from Cubit/Bloc and render. No repository or direct service locator imports in UI.
7. **L10n & Central Routing:** Strings must be localized in `app_en.arb` and `app_ar.arb`. Routes are declared in `RouteNames` and `AppRouter`.
8. **Design Tokens & Logging:** Use theme tokens and `AppLogger`. No raw `print()` calls.

---

## 4. Mandatory Verification Pipeline

Before opening a pull request or submitting changes, all checks must pass cleanly with **0 errors and 0 warnings**:

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run code generation
dart run build_runner build --delete-conflicting-outputs

# 3. Format all Dart files
dart format --set-exit-if-changed .

# 4. Static analysis (must report 0 issues)
flutter analyze

# 5. Architecture validation (must report 0 violations)
dart run tool/check_architecture.dart
```

Pull requests will fail in GitHub Actions CI if any of these checks fail.
