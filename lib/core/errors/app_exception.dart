/// Base exception class for all expected domain and network application errors.
class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;
  final Object? originalError;

  const AppException({
    required this.message,
    this.code,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() =>
      'AppException(code: $code, message: $message, statusCode: $statusCode)';
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Connection timed out',
    super.code = 'TIMEOUT_ERROR',
    super.originalError,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Authentication required',
    super.code = 'UNAUTHORIZED',
    super.statusCode = 401,
    super.originalError,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Permission denied',
    super.code = 'FORBIDDEN',
    super.statusCode = 403,
    super.originalError,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 'NOT_FOUND',
    super.statusCode = 404,
    super.originalError,
  });
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;

  const ValidationException({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    super.statusCode = 400,
    this.fieldErrors = const {},
    super.originalError,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server encountered an error',
    super.code = 'SERVER_ERROR',
    super.statusCode = 500,
    super.originalError,
  });
}

class CancelledException extends AppException {
  const CancelledException({
    super.message = 'Operation was cancelled',
    super.code = 'CANCELLED',
    super.originalError,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });
}
