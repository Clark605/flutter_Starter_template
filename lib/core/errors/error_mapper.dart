import 'dart:async' as async;
import 'package:dio/dio.dart';
import 'package:flutter_starter/core/errors/app_exception.dart';
import 'package:flutter_starter/core/errors/failure.dart';

class ErrorMapper {
  ErrorMapper._();

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

    if (error is DioException) {
      return _mapDioException(error, stackTrace);
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

    // Check if error is socket/network related without importing dart:io directly
    final errStr = error.toString().toLowerCase();
    if (errStr.contains('socketexception') ||
        errStr.contains('connection refused') ||
        errStr.contains('network is unreachable')) {
      return Failure.network(originalError: error, stackTrace: stackTrace);
    }

    return Failure.unknown(originalError: error, stackTrace: stackTrace);
  }

  static Failure _mapDioException(DioException dioErr, StackTrace? stackTrace) {
    switch (dioErr.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure.timeout(originalError: dioErr, stackTrace: stackTrace);

      case DioExceptionType.connectionError:
        return Failure.network(originalError: dioErr, stackTrace: stackTrace);

      case DioExceptionType.cancel:
        return Failure.cancelled(originalError: dioErr, stackTrace: stackTrace);

      case DioExceptionType.badResponse:
        final status = dioErr.response?.statusCode;
        final data = dioErr.response?.data;

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
            fieldErrors: fieldErrors,
            originalError: dioErr,
            stackTrace: stackTrace,
          ),
          401 => Failure.unauthorized(
            originalError: dioErr,
            stackTrace: stackTrace,
          ),
          403 => Failure.forbidden(
            originalError: dioErr,
            stackTrace: stackTrace,
          ),
          404 => Failure.notFound(
            originalError: dioErr,
            stackTrace: stackTrace,
          ),
          _ => Failure.server(
            statusCode: status,
            originalError: dioErr,
            stackTrace: stackTrace,
          ),
        };

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        final inner = dioErr.error;
        if (inner != null) {
          final innerStr = inner.toString().toLowerCase();
          if (innerStr.contains('socketexception')) {
            return Failure.network(
              originalError: dioErr,
              stackTrace: stackTrace,
            );
          }
        }
        return Failure.unknown(originalError: dioErr, stackTrace: stackTrace);
    }
  }
}
