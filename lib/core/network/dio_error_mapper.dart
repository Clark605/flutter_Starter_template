import 'package:dio/dio.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/network/is_socket_error.dart';

/// Pluggable mapper that transforms [DioException] into domain-level [Failure].
Failure? mapDioException(Object error, [StackTrace? stackTrace]) {
  if (error is! DioException) return null;

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return Failure.timeout(originalError: error, stackTrace: stackTrace);

    case DioExceptionType.connectionError:
      return Failure.network(originalError: error, stackTrace: stackTrace);

    case DioExceptionType.cancel:
      return Failure.cancelled(originalError: error, stackTrace: stackTrace);

    case DioExceptionType.badResponse:
      final status = error.response?.statusCode;
      final data = error.response?.data;

      final Map<String, List<String>> fieldErrors = {};
      if (data is Map<String, dynamic>) {
        final errorsObj = data['errors'] ?? data['Errors'];
        if (errorsObj is Map<String, dynamic>) {
          for (final entry in errorsObj.entries) {
            if (entry.value is List) {
              fieldErrors[entry.key] = (entry.value as List)
                  .map((e) => e.toString())
                  .toList();
            }
          }
        }
      }

      return switch (status) {
        400 => Failure.validation(
          code: 'BAD_REQUEST',
          fieldErrors: fieldErrors,
          originalError: error,
          stackTrace: stackTrace,
        ),
        401 => Failure.unauthorized(
          originalError: error,
          stackTrace: stackTrace,
        ),
        403 => Failure.forbidden(originalError: error, stackTrace: stackTrace),
        404 => Failure.notFound(originalError: error, stackTrace: stackTrace),
        408 => Failure.timeout(
          code: 'REQUEST_TIMEOUT',
          originalError: error,
          stackTrace: stackTrace,
        ),
        409 => Failure.conflict(originalError: error, stackTrace: stackTrace),
        422 => Failure.validation(
          code: 'UNPROCESSABLE_ENTITY',
          fieldErrors: fieldErrors,
          originalError: error,
          stackTrace: stackTrace,
        ),
        429 => Failure.server(
          code: 'TOO_MANY_REQUESTS',
          statusCode: 429,
          isRetryable: true,
          originalError: error,
          stackTrace: stackTrace,
        ),
        502 || 503 || 504 => Failure.server(
          code: 'SERVER_UNAVAILABLE',
          statusCode: status,
          isRetryable: true,
          originalError: error,
          stackTrace: stackTrace,
        ),
        _ => Failure.server(
          statusCode: status,
          isRetryable: false,
          originalError: error,
          stackTrace: stackTrace,
        ),
      };

    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
    default:
      final inner = error.error;
      if (inner != null && isSocketError(inner)) {
        return Failure.network(originalError: error, stackTrace: stackTrace);
      }
      return Failure.unknown(originalError: error, stackTrace: stackTrace);
  }
}
