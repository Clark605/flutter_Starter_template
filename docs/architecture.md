# Architectural Blueprint

`flutter_starter` implements a modular, feature-first Clean Architecture without the overhead of an artificial domain layer. Presentation logic depends exclusively on repository interfaces (`i_<feature>_repository.dart`), ensuring high testability, fast compilation, and seamless backend independence.

```mermaid
flowchart TD
    subgraph UI ["Presentation Layer (UI)"]
        Screen["FeatureScreen\n(Thin View)"]
        Widget["FeatureWidgets"]
        Screen --> Widget
    end

    subgraph StateManagement ["State Management"]
        Cubit["FeatureCubit / Bloc\n(with ActionGuard)"]
        State["FeatureState\n(Freezed Unions)"]
        Cubit --> State
    end

    subgraph RepositoryLayer ["Data Boundary (Interface)"]
        RepoInterface["IFeatureRepository\n(Returns Result<T>)"]
    end

    subgraph DataLayer ["Data Layer (Implementation)"]
        RepoImpl["FeatureRepositoryImpl\n(@LazySingleton)"]
        RemoteDS["RemoteDataSource\n(Dio / Firebase / etc.)"]
        LocalDS["LocalDataSource\n(Drift / SharedPreferences)"]
        DTO["DTO Models\n(Freezed + JSON)"]

        RepoImpl --> RemoteDS
        RepoImpl --> LocalDS
        RemoteDS --> DTO
    end

    UI --> Cubit
    Cubit --> RepoInterface
    RepoInterface -.-> RepoImpl
```

---

## 1. The Seam: Why There Is No Domain Layer
Traditional "Clean Architecture" in Flutter frequently introduces three boilerplate layers for every feature: `Entity`, `UseCase`, and `Repository`. In 95% of mobile features, `UseCase` merely calls `Repository.method()` without adding logic.

In `flutter_starter`:
- **Repository Interface is the Domain Contract**: It defines business capability and returns `Result<T>`.
- **DTOs are Immutable Values**: Freezed models (`*.freezed.dart`, `*.g.dart`) provide serialization, deep equality, and `copyWith`.
- **No Direct Data Source Leaks**: Cubits never see Dio, Firebase, or Supabase.

---

## 2. Guarded Actions (`ActionGuard` vs `SafeActionCubit`)

### Why Legacy `SafeActionCubit` was Replaced:
| Legacy `SafeActionCubit` | Modern `ActionGuard<S>` Mixin |
|---|---|
| Returns `null` on failure (ambiguous with valid `null`). | Returns sealed `Result<T>` (`Success` or `Error`). |
| Bound strictly to Cubit hierarchy. | Reusable mixin on `BlocBase<S>` (works for Cubits and Blocs). |
| Swallows errors into ad-hoc callback. | Central `ErrorMapper` transforms exceptions to typed `Failure`. |
| No re-entrancy / double-submit protection. | Optional action `key` drops duplicate concurrent calls. |
| No retry support. | Configurable exponential backoff retries for transient errors. |
| Hardcoded English strings. | Every `Failure` carries a localization translation key. |

### Cubit Example:
```dart
@injectable
class ItemsCubit extends BaseCubit<ItemsState> {
  final IItemsRepository _repository;

  ItemsCubit(this._repository) : super(const ItemsState.initial());

  Future<void> fetchItems() async {
    emit(const ItemsState.loading());

    final result = await guard<List<ItemDto>>(
      () => _repository.getItems().then((res) => res.fold((data) => data, (err) => throw err)),
      key: 'fetch_items',
      retries: 2,
    );

    result.fold(
      (items) => emit(ItemsState.loaded(items)),
      (failure) => emit(ItemsState.error(failure)),
    );
  }
}
```

### Bloc Example (with `Emitter.isDone` Safety):
```dart
@injectable
class ItemDetailBloc extends Bloc<ItemDetailEvent, ItemDetailState> with ActionGuard<ItemDetailState> {
  final IItemsRepository _repository;

  ItemDetailBloc(this._repository) : super(const ItemDetailState.initial()) {
    on<LoadItemDetail>((event, emit) async {
      emit(const ItemDetailState.loading());

      final result = await guard<ItemDto>(
        () => _repository.getItem(event.id).then((r) => r.fold((d) => d, (e) => throw e)),
        key: 'detail_${event.id}',
        emitter: emit, // Checked for emitter.isDone
      );

      result.fold(
        (item) => emit(ItemDetailState.loaded(item)),
        (failure) => emit(ItemDetailState.error(failure)),
      );
    });
  }
}
```

---

## 3. Sealed Results and Failures

```dart
final result = await repository.getItem(id);

switch (result) {
  case Success(data: final item):
    showItem(item);
  case Error(failure: final failure):
    showSnackbar(failure.localizedMessage(context));
}
```

Failures include:
- `NetworkFailure` (`NETWORK_ERROR`, retryable)
- `TimeoutFailure` (`TIMEOUT_ERROR`, retryable)
- `UnauthorizedFailure` (`UNAUTHORIZED`)
- `ForbiddenFailure` (`FORBIDDEN`)
- `NotFoundFailure` (`NOT_FOUND`)
- `ValidationFailure` (`VALIDATION_ERROR`, includes `fieldErrors`)
- `ServerFailure` (`SERVER_ERROR`, includes HTTP status code)
- `CancelledFailure` (`CANCELLED`)
- `UnknownFailure` (`UNKNOWN_ERROR`)

---

## 4. Startup Bootstrap Sequence

The application boot flow in [`lib/bootstrap.dart`](file:///d:/MyProgrammingProjects/FlutterProjects/my_flutter_template/lib/bootstrap.dart) is engineered for resilience, ensuring the splash screen is never hung:

1. **Native Splash Preservation**: Calls `FlutterNativeSplash.preserve()` immediately after `WidgetsFlutterBinding.ensureInitialized()` to prevent white/black flash before initial frame.
2. **Early Error Buffering**: Installs `FlutterError.onError` and `PlatformDispatcher.instance.onError` before DI. Logs all errors immediately and buffers them in memory.
3. **Dependency Injection**: Invokes `configureDependencies()` to register core services, Dio networking, storage, and repositories.
4. **Crash Reporter Online & Buffer Flush**: Initializes `ICrashReporter` (No-Op default, Firebase Crashlytics or Sentry via optional modules) and flushes any pre-initialization errors.
5. **Remote Config with Timeout**: Calls `remoteConfig.init()` and `fetchAndActivate()` bounded by `AppConfig.remoteConfigTimeout` (default: 3 seconds). If network stalls or times out, it gracefully falls back to compile-time defaults.
6. **Force-Update & Maintenance Gate**: Evaluates `ForceUpdateGate` against min version and maintenance flags:
   - `GateStatus.maintenance` $\to$ Routes to [`MaintenanceScreen`](file:///d:/MyProgrammingProjects/FlutterProjects/my_flutter_template/lib/core/widgets/screens/maintenance_screen.dart) (`/maintenance`) with back-navigation blocked.
   - `GateStatus.updateRequired` $\to$ Routes to [`UpdateRequiredScreen`](file:///d:/MyProgrammingProjects/FlutterProjects/my_flutter_template/lib/core/widgets/screens/update_required_screen.dart) (`/update-required`) with store launch link.
   - `GateStatus.normal` $\to$ Routes to onboarding or home screen based on `PrefsService.hasSeenOnboarding`.
7. **Guaranteed Splash Removal**: Handled in a `finally` block with `FlutterNativeSplash.remove()` so that even in case of an uncaught boot exception, the splash is cleared and the app transitions to `RouteNames.error`.
