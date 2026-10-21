// Copy to lib/core/services/signalr_service.dart when signalr_netcore is added.
/*
import 'dart:async';
import 'package:flutter_starter/core/network/token_provider.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_netcore.dart';

enum RealtimeConnectionStatus { disconnected, connecting, connected, reconnecting }

@lazySingleton
class SignalRService {
  final TokenProvider _tokenProvider;
  HubConnection? _hubConnection;

  final StreamController<RealtimeConnectionStatus> _statusController =
      StreamController<RealtimeConnectionStatus>.broadcast();

  Stream<RealtimeConnectionStatus> get onStatusChanged => _statusController.stream;

  SignalRService(this._tokenProvider);

  Future<void> connect(String hubUrl) async {
    if (_hubConnection?.state == HubConnectionState.Connected) return;

    _statusController.add(RealtimeConnectionStatus.connecting);

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () => _tokenProvider.getAccessToken().then((t) => t ?? ''),
          ),
        )
        .withAutomaticReconnect()
        .build();

    _hubConnection?.onclose(({error}) {
      AppLogger.warning('SignalR connection closed', tag: 'SignalR', error: error);
      _statusController.add(RealtimeConnectionStatus.disconnected);
    });

    _hubConnection?.onreconnecting(({error}) {
      AppLogger.warning('SignalR reconnecting', tag: 'SignalR', error: error);
      _statusController.add(RealtimeConnectionStatus.reconnecting);
    });

    _hubConnection?.onreconnected(({connectionId}) {
      AppLogger.info('SignalR reconnected: $connectionId', tag: 'SignalR');
      _statusController.add(RealtimeConnectionStatus.connected);
    });

    try {
      await _hubConnection?.start();
      _statusController.add(RealtimeConnectionStatus.connected);
      AppLogger.info('SignalR connected to $hubUrl', tag: 'SignalR');
    } catch (e, st) {
      AppLogger.error('SignalR failed to connect', tag: 'SignalR', error: e, stackTrace: st);
      _statusController.add(RealtimeConnectionStatus.disconnected);
    }
  }

  void on(String methodName, void Function(List<Object?>? args) handler) {
    _hubConnection?.on(methodName, handler);
  }

  void off(String methodName) {
    _hubConnection?.off(methodName);
  }

  Future<void> invoke(String methodName, {List<Object>? args}) async {
    await _hubConnection?.invoke(methodName, args: args);
  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _statusController.add(RealtimeConnectionStatus.disconnected);
  }
}
*/
