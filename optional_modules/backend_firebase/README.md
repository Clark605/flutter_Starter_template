# Backend Variant: Firebase (Firestore)

Demonstrates swapping the REST (Dio) datasource with Google Cloud Firestore while keeping `ItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  cloud_firestore: ^5.6.5
  firebase_core: ^3.12.1
```

## 2. Registering Custom Error Mapper

Register a Firebase error mapper with `ErrorMapper` in `lib/bootstrap.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/failure.dart';

Failure? mapFirebaseException(Object error, [StackTrace? stackTrace]) {
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' => Failure.forbidden(
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      ),
      'not-found' => Failure.notFound(
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      ),
      'already-exists' => Failure.conflict(
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      ),
      'unavailable' || 'deadline-exceeded' => Failure.server(
        code: error.code,
        isRetryable: true,
        originalError: error,
        stackTrace: stackTrace,
      ),
      _ => Failure.server(
        code: error.code,
        originalError: error,
        stackTrace: stackTrace,
      ),
    };
  }
  return null;
}

// In bootstrap():
ErrorMapper.register(mapFirebaseException);
```

## 3. Architecture Swap Point

In this architecture, Cubits and Blocs depend strictly on `ItemRepository` (which returns `Result<T>`).
The repository delegates to `ItemRemoteDataSource`.

To switch to Firebase:
1. Replace `ItemRemoteDataSourceImpl` with `FirebaseItemRemoteDataSourceImpl`.
2. Register it with `@LazySingleton(as: ItemRemoteDataSource)`.
3. Register the custom Firebase error mapper via `ErrorMapper.register(mapFirebaseException)`.
4. Zero lines of UI or Cubit code need to change.
