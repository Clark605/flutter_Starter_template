# Optional Modules Catalog

All optional modules are kept outside `lib/` in `optional_modules/<name>/`. Each module is self-contained with its own dependencies list, source files, and integration instructions.

| Module | Location | Purpose | Dependencies |
|---|---|---|---|
| **Auth** | `optional_modules/auth/` | Single in-flight token refresh mutex, biometric lock, secure storage | `flutter_secure_storage`, `local_auth` |
| **Push Notifications** | `optional_modules/push_notifications/` | FCM push notifications + heads-up local alerts | `firebase_messaging`, `flutter_local_notifications` |
| **Deep Links** | `optional_modules/deep_links/` | App Links / Universal Links router integration | `app_links` |
| **Local DB** | `optional_modules/local_db/` | Drift SQLite database + cache-first repository pattern | `drift`, `drift_flutter` |
| **Firebase** | `optional_modules/firebase/` | Implements `ICrashReporter`, `IAnalyticsService`, `IRemoteConfigService` | `firebase_crashlytics`, `firebase_analytics`, `firebase_remote_config` |
| **Sentry** | `optional_modules/sentry/` | Implements `ICrashReporter` via Sentry | `sentry_flutter` |
| **SignalR** | `optional_modules/signalr/` | Realtime websocket hub with auto-reconnection and token auth | `signalr_netcore` |
| **Web** | `optional_modules/web/` | Web URL strategy (`path` without `#`), CORS and responsive notes | `flutter_web_plugins` |
| **Backend: Firebase** | `optional_modules/backend_firebase/` | Firestore-backed remote data source | `cloud_firestore` |
| **Backend: Supabase** | `optional_modules/backend_supabase/` | Supabase PostgREST-backed remote data source | `supabase_flutter` |
| **Backend: GraphQL** | `optional_modules/backend_graphql/` | GraphQL query and mutation remote data source | `graphql_flutter` |
