import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration baseDelay;

  static const Set<String> _idempotentMethods = {
    'GET',
    'HEAD',
    'PUT',
    'DELETE',
    'OPTIONS',
  };

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 500),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final method = requestOptions.method.toUpperCase();

    if (!_idempotentMethods.contains(method)) {
      return handler.next(err);
    }

    final isTransient = switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      _ => false,
    };

    if (!isTransient) {
      return handler.next(err);
    }

    final currentAttempt =
        (requestOptions.extra['retry_attempt'] as int? ?? 0) + 1;

    if (currentAttempt > maxRetries) {
      return handler.next(err);
    }

    requestOptions.extra['retry_attempt'] = currentAttempt;
    final delay = baseDelay * (1 << (currentAttempt - 1));

    AppLogger.warning(
      'Retrying request [${requestOptions.method} ${requestOptions.path}] (attempt $currentAttempt/$maxRetries after ${delay.inMilliseconds}ms)',
      tag: 'RetryInterceptor',
    );

    await Future<void>.delayed(delay);

    try {
      final response = await dio.fetch(requestOptions);
      return handler.resolve(response);
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    } on Object catch (e) {
      return handler.next(
        DioException(requestOptions: requestOptions, error: e),
      );
    }
  }
}
