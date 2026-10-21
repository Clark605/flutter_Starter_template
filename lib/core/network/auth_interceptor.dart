import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/token_provider.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;

  static final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();
  static Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  static void notifySessionExpired() {
    _sessionExpiredController.add(null);
  }

  AuthInterceptor(this._tokenProvider);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If authorization header is already manually supplied, do not overwrite
    if (!options.headers.containsKey('Authorization')) {
      final token = await _tokenProvider.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      notifySessionExpired();
    }
    handler.next(err);
  }
}
