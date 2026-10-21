# Backend Variant: Supabase

Demonstrates swapping the REST (Dio) datasource with Supabase (PostgREST + Realtime) while keeping `IItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  supabase_flutter: ^2.8.4
```

## 2. Initialization

In `lib/bootstrap.dart`:
```dart
await Supabase.initialize(
  url: 'https://xyzcompany.supabase.co',
  anonKey: 'public-anon-key',
);
```

## 3. Architecture Swap Point

1. Provide `SupabaseItemRemoteDataSourceImpl` implementing `IItemRemoteDataSource`.
2. Register it with `@LazySingleton(as: IItemRemoteDataSource)`.
3. Run `dart run build_runner build --delete-conflicting-outputs`.
