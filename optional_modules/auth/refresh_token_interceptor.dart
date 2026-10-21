import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/constants/api_constants.dart';
import 'package:flutter_starter/core/network/auth_interceptor.dart';
import 'package:flutter_starter/core/storage/secure_storage_service.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

class RefreshTokenInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final Dio Function() _dioFactory;

  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
  _pendingQueue = [];

  RefreshTokenInterceptor(this._secureStorage, {Dio Function()? dioFactory})
    : _dioFactory =
          dioFactory ?? (() => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)));

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final path = err.requestOptions.path;
    if (path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.register) ||
        path.contains(ApiConstants.refresh)) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      _pendingQueue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _failPendingRequests(err);
        AuthInterceptor.notifySessionExpired();
        return handler.next(err);
      }

      final refreshDio = _dioFactory();
      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = (data['accessToken'] ?? data['token']) as String;
      final newRefreshToken = (data['refreshToken'] ?? refreshToken) as String;

      await _secureStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // Replay the failed original request
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer $newAccessToken';
      final replayedResponse = await refreshDio.fetch(options);
      handler.resolve(replayedResponse);

      // Replay all pending queued requests
      for (final pending in _pendingQueue) {
        pending.options.headers['Authorization'] = 'Bearer $newAccessToken';
        try {
          final res = await refreshDio.fetch(pending.options);
          pending.handler.resolve(res);
        } on DioException catch (e) {
          pending.handler.next(e);
        }
      }
    } on Object catch (refreshErr, st) {
      AppLogger.error(
        'Token refresh failed',
        tag: 'Auth',
        error: refreshErr,
        stackTrace: st,
      );
      await _secureStorage.clearTokens();
      _failPendingRequests(err);
      AuthInterceptor.notifySessionExpired();
      handler.next(err);
    } finally {
      _isRefreshing = false;
      _pendingQueue.clear();
    }
  }

  void _failPendingRequests(DioException err) {
    for (final pending in _pendingQueue) {
      pending.handler.next(err);
    }
  }
}
