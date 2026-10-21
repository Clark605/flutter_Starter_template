# Backend Variant: GraphQL

Demonstrates swapping the REST (Dio) datasource with GraphQL queries and mutations while keeping `IItemRepository`, `ExampleCubit`, and the UI 100% unchanged.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  graphql_flutter: ^5.1.2
```

## 2. Architecture Swap Point

1. Provide `GraphQLItemRemoteDataSourceImpl` implementing `IItemRemoteDataSource`.
2. Register it with `@LazySingleton(as: IItemRemoteDataSource)`.
3. Wrap GraphQL queries inside the data source and return `ItemDto`.
4. The repository and presentation layers remain backend-agnostic.
