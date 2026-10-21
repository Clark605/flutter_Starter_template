import 'dart:async' as async;
import 'package:flutter_starter/core/errors/app_exception.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/network/is_socket_error.dart';

typedef CustomErrorMapper =
    Failure? Function(Object error, [StackTrace? stackTrace]);

class ErrorMapper {
  ErrorMapper._();

  static final List<CustomErrorMapper> _customMappers = [];

  /// Registers a custom failure mapper for specific transport or third-party exceptions.
  ///
  /// Mappers are evaluated in order before fallback unknown mapping.
  static void register(CustomErrorMapper mapper) {
    if (!_customMappers.contains(mapper)) {
      _customMappers.add(mapper);
    }
  }

  /// Clears all registered custom error mappers (useful for testing or reconfiguration).
  static void clearMappers() {
    _customMappers.clear();
  }

  static Failure map(Object error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    if (error is AppException) {
      return switch (error) {
        NetworkException() => Failure.network(
          code: error.code ?? 'NETWORK_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ),
        TimeoutException() => Failure.timeout(
          code: error.code ?? 'TIMEOUT_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ),
        UnauthorizedException() => Failure.unauthorized(
          code: error.code ?? 'UNAUTHORIZED',
          originalError: error,
          stackTrace: stackTrace,
        ),
        ForbiddenException() => Failure.forbidden(
          code: error.code ?? 'FORBIDDEN',
          originalError: error,
          stackTrace: stackTrace,
        ),
        NotFoundException() => Failure.notFound(
          code: error.code ?? 'NOT_FOUND',
          originalError: error,
          stackTrace: stackTrace,
        ),
        ValidationException(fieldErrors: final fe) => Failure.validation(
          code: error.code ?? 'VALIDATION_ERROR',
          fieldErrors: fe,
          originalError: error,
          stackTrace: stackTrace,
        ),
        ServerException(statusCode: final sc) => Failure.server(
          code: error.code ?? 'SERVER_ERROR',
          statusCode: sc,
          originalError: error,
          stackTrace: stackTrace,
        ),
        CancelledException() => Failure.cancelled(
          code: error.code ?? 'CANCELLED',
          originalError: error,
          stackTrace: stackTrace,
        ),
        UnknownException() => Failure.unknown(
          code: error.code ?? 'UNKNOWN_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ),
        _ => Failure.unknown(
          code: error.code ?? 'UNKNOWN_ERROR',
          originalError: error,
          stackTrace: stackTrace,
        ),
      };
    }

    // Evaluate registered pluggable mappers (e.g. Dio, Firebase, Supabase, GraphQL)
    for (final mapper in _customMappers) {
      final mapped = mapper(error, stackTrace);
      if (mapped != null) {
        return mapped;
      }
    }

    if (error is async.TimeoutException) {
      return Failure.timeout(originalError: error, stackTrace: stackTrace);
    }

    if (error is FormatException) {
      return Failure.validation(
        code: 'FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (isSocketError(error)) {
      return Failure.network(originalError: error, stackTrace: stackTrace);
    }

    return Failure.unknown(originalError: error, stackTrace: stackTrace);
  }
}
