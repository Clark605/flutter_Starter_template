# Backend Variant: GraphQL

Demonstrates swapping the REST (Dio) datasource with GraphQL queries and mutations while keeping `ItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  graphql_flutter: ^5.1.2
```

## 2. Registering Custom Error Mapper

Register a GraphQL error mapper in `lib/bootstrap.dart`:

```dart
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

Failure? mapGraphQLException(Object error, [StackTrace? stackTrace]) {
  if (error is OperationException) {
    if (error.linkException != null) {
      return Failure.network(originalError: error, stackTrace: stackTrace);
    }
    if (error.graphqlErrors.isNotEmpty) {
      final first = error.graphqlErrors.first;
      final code = first.extensions?['code']?.toString() ?? 'GRAPHQL_ERROR';
      if (code == 'UNAUTHENTICATED') {
        return Failure.unauthorized(code: code, originalError: error, stackTrace: stackTrace);
      }
      return Failure.server(code: code, originalError: error, stackTrace: stackTrace);
    }
  }
  return null;
}

// In bootstrap():
ErrorMapper.register(mapGraphQLException);
```

## 3. Architecture Swap Point

1. Provide `GraphQLItemRemoteDataSourceImpl` implementing `ItemRemoteDataSource`.
2. Register it with `@LazySingleton(as: ItemRemoteDataSource)`.
3. Wrap GraphQL queries inside the data source and return `ItemModel`.
4. Register the error mapper with `ErrorMapper.register(mapGraphQLException)`.
5. The repository and presentation layers remain backend-agnostic.
