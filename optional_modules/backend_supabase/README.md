# Backend Variant: Supabase

Demonstrates swapping the REST (Dio) datasource with Supabase (PostgREST + Realtime) while keeping `ItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  supabase_flutter: ^2.8.4
```

## 2. Initialization & Error Mapping

In `lib/bootstrap.dart`:

```dart
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Failure? mapSupabaseException(Object error, [StackTrace? stackTrace]) {
  if (error is AuthException) {
    return switch (error.statusCode) {
      '401' => Failure.unauthorized(code: error.code, originalError: error, stackTrace: stackTrace),
      '403' => Failure.forbidden(code: error.code, originalError: error, stackTrace: stackTrace),
      _ => Failure.unauthorized(code: error.code, originalError: error, stackTrace: stackTrace),
    };
  }
  if (error is PostgrestException) {
    return switch (error.code) {
      '23505' => Failure.conflict(code: error.code ?? 'UNIQUE_VIOLATION', originalError: error, stackTrace: stackTrace),
      'PGRST116' => Failure.notFound(code: 'NOT_FOUND', originalError: error, stackTrace: stackTrace),
      _ => Failure.server(code: error.code ?? 'POSTGREST_ERROR', originalError: error, stackTrace: stackTrace),
    };
  }
  return null;
}

// In bootstrap():
await Supabase.initialize(
  url: 'https://xyzcompany.supabase.co',
  anonKey: 'public-anon-key',
);
ErrorMapper.register(mapSupabaseException);
```

## 3. Architecture Swap Point

1. Provide `SupabaseItemRemoteDataSourceImpl` implementing `ItemRemoteDataSource`.
2. Register it with `@LazySingleton(as: ItemRemoteDataSource)`.
3. Register the Supabase error mapper with `ErrorMapper.register(...)`.
4. Run `dart run build_runner build --delete-conflicting-outputs`.
