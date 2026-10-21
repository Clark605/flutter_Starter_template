import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract interface class IConnectivityService {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
}

@LazySingleton(as: IConnectivityService)
class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService() : _connectivity = Connectivity();

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return _hasConnection(results);
    }).distinct();
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return !results.contains(ConnectivityResult.none);
  }
}
