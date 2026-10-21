# Backend-Agnostic Architecture & Swap Points

A key guarantee of `flutter_starter` is that the presentation layer (`cubit/`, `bloc/`, `ui/`) and core contracts are 100% agnostic to your backend provider.

---

## 1. The Seam: `I<Feature>Repository`

```
   ┌───────────────────────┐
   │ FeatureCubit / Bloc   │
   └───────────┬───────────┘
               │ Calls repository interface
               ▼
   ┌───────────────────────┐
   │  IItemRepository      │ ◄─── Strict Seam
   │  (Returns Result<T>)  │
   └───────────┬───────────┘
               │ Implemented by
               ▼
   ┌───────────────────────────────────────────────┐
   │             Repository Implementation         │
   │  (ItemRepositoryImpl / CachedItemRepository)  │
   └───────────────────────┬───────────────────────┘
                           │ Delegates to
                           ▼
          ┌───────────────────────────────────┐
          │     IItemRemoteDataSource         │
          └─┬──────────────┬───────────────┬──┘
            │              │               │
     REST (Dio)       Firebase         Supabase / GraphQL
```

---

## 2. Supported Backend Variants

Reference implementations for each variant are located under `optional_modules/`:

### A. REST via Dio (Default)
Fully implemented in the base template with timeouts, JSON headers, retry-with-backoff, token authorization, and debug log sanitization.
- Remote data source: `lib/features/example/data/datasources/item_remote_data_source.dart`

### B. Cloud Firestore (Firebase)
- Reference: `optional_modules/backend_firebase/`
- Implements `IItemRemoteDataSource` using `FirebaseFirestore.instance.collection(...)`.
- Repository catches `FirebaseException` and maps via `ErrorMapper`.

### C. Supabase
- Reference: `optional_modules/backend_supabase/`
- Implements `IItemRemoteDataSource` using `SupabaseClient.from(...).select()`.
- Repository catches `PostgrestException` and maps via `ErrorMapper`.

### D. GraphQL
- Reference: `optional_modules/backend_graphql/`
- Implements `IItemRemoteDataSource` with typed GraphQL queries and mutations via `GraphQLClient`.
