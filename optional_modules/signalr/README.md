# SignalR Realtime Service Optional Module

Generalized realtime streaming architecture. Provides resilient SignalR hub connection with automatic reconnection, state streaming, and token authorization.

## 1. Dependencies to Add to `pubspec.yaml`

```yaml
dependencies:
  signalr_netcore: ^1.4.4
```

## 2. Wiring Steps

1. Copy `signalr_service.dart` into `lib/core/services/`.
2. Register as `@lazySingleton` or initialize with your backend's Hub URL.
3. Subscribe to realtime events in relevant feature Blocs/Cubits.
