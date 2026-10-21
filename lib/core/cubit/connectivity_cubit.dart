import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/connectivity_state.dart';
import 'package:flutter_starter/core/services/connectivity_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityCubit extends Cubit<ConnectivityState> {
  final IConnectivityService _connectivityService;
  StreamSubscription<bool>? _subscription;

  ConnectivityCubit(this._connectivityService)
    : super(const ConnectivityState()) {
    _init();
  }

  Future<void> _init() async {
    final connected = await _connectivityService.isConnected;
    if (!isClosed) {
      emit(state.copyWith(isOnline: connected, hasCheckedInitial: true));
    }

    _subscription = _connectivityService.onConnectivityChanged.listen((
      isOnline,
    ) {
      if (!isClosed) {
        emit(state.copyWith(isOnline: isOnline));
      }
    });
  }

  Future<void> refresh() async {
    final connected = await _connectivityService.isConnected;
    if (!isClosed) {
      emit(state.copyWith(isOnline: connected));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
