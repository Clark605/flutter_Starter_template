# Local Database (Drift) Optional Module

Type-safe, reactive SQLite persistence with Drift and offline-first / cache-first repository integration.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  drift: ^2.24.2
  drift_flutter: ^0.2.4

dev_dependencies:
  drift_dev: ^2.24.2
```

## 2. Architecture & Cache-First Pattern

When using local caching with Drift, the feature repository remains the seam:
1. `ItemRepository` returns `Result<List<ItemModel>>`.
2. `CachedItemRepositoryImpl` reads from `AppDatabase.itemsDao` first.
3. If fresh cache exists, emits/returns immediately.
4. Queries remote API (`ItemRemoteDataSource`), updates SQLite, and returns updated data.
5. If remote call fails while offline, returns cached data safely without surfacing network errors to the UI.
