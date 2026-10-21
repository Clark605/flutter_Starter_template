# Backend Variant: Firebase (Firestore)

Demonstrates swapping the REST (Dio) datasource with Google Cloud Firestore while keeping `IItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  cloud_firestore: ^5.6.5
  firebase_core: ^3.12.1
```

## 2. Architecture Swap Point

In this architecture, Cubits and Blocs depend strictly on `IItemRepository` (which returns `Result<T>`).
The repository delegates to `IItemRemoteDataSource`.

To switch to Firebase:
1. Replace `ItemRemoteDataSourceImpl` with `FirebaseItemRemoteDataSourceImpl`.
2. Register it with `@LazySingleton(as: IItemRemoteDataSource)`.
3. The repository implementation catches `FirebaseException` instead of `DioException` and maps it through `ErrorMapper`.
4. Zero lines of UI or Cubit code need to change.
