import 'package:flutter/widgets.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';

sealed class Failure {
  final String code;
  final String localizationKey;
  final Object? originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.code,
    required this.localizationKey,
    this.originalError,
    this.stackTrace,
  });

  String localizedMessage(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      NetworkFailure() => l10n.errorNetwork,
      TimeoutFailure() => l10n.errorTimeout,
      UnauthorizedFailure() => l10n.errorUnauthorized,
      ForbiddenFailure() => l10n.errorForbidden,
      NotFoundFailure() => l10n.errorNotFound,
      ConflictFailure() => l10n.errorConflict,
      ValidationFailure() => l10n.errorValidation,
      ServerFailure() => l10n.errorServer,
      CancelledFailure() => l10n.errorCancelled,
      UnknownFailure() => l10n.errorUnknown,
    };
  }

  const factory Failure.network({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = NetworkFailure;

  const factory Failure.timeout({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = TimeoutFailure;

  const factory Failure.unauthorized({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnauthorizedFailure;

  const factory Failure.forbidden({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = ForbiddenFailure;

  const factory Failure.notFound({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = NotFoundFailure;

  const factory Failure.conflict({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = ConflictFailure;

  const factory Failure.validation({
    String code,
    String localizationKey,
    Map<String, List<String>> fieldErrors,
    Object? originalError,
    StackTrace? stackTrace,
  }) = ValidationFailure;

  const factory Failure.server({
    String code,
    String localizationKey,
    int? statusCode,
    Object? originalError,
    StackTrace? stackTrace,
  }) = ServerFailure;

  const factory Failure.cancelled({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = CancelledFailure;

  const factory Failure.unknown({
    String code,
    String localizationKey,
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.code = 'NETWORK_ERROR',
    super.localizationKey = 'errorNetwork',
    super.originalError,
    super.stackTrace,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.code = 'TIMEOUT_ERROR',
    super.localizationKey = 'errorTimeout',
    super.originalError,
    super.stackTrace,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.code = 'UNAUTHORIZED',
    super.localizationKey = 'errorUnauthorized',
    super.originalError,
    super.stackTrace,
  });
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    super.code = 'FORBIDDEN',
    super.localizationKey = 'errorForbidden',
    super.originalError,
    super.stackTrace,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.code = 'NOT_FOUND',
    super.localizationKey = 'errorNotFound',
    super.originalError,
    super.stackTrace,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.code = 'CONFLICT',
    super.localizationKey = 'errorConflict',
    super.originalError,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;

  const ValidationFailure({
    super.code = 'VALIDATION_ERROR',
    super.localizationKey = 'errorValidation',
    this.fieldErrors = const {},
    super.originalError,
    super.stackTrace,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.code = 'SERVER_ERROR',
    super.localizationKey = 'errorServer',
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

class CancelledFailure extends Failure {
  const CancelledFailure({
    super.code = 'CANCELLED',
    super.localizationKey = 'errorCancelled',
    super.originalError,
    super.stackTrace,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.code = 'UNKNOWN_ERROR',
    super.localizationKey = 'errorUnknown',
    super.originalError,
    super.stackTrace,
  });
}
