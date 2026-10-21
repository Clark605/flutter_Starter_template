import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/core/observability/crash_reporter.dart';
import 'package:flutter_starter/core/utils/action_token.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

/// Configuration hook for [ActionGuard].
///
/// Configured during bootstrap so [ActionGuard] does not access the service locator directly.
class ActionGuardConfig {
  ActionGuardConfig._();

  /// Global crash reporter hook used by [ActionGuard] to forward unexpected errors.
  static ICrashReporter? crashReporter;
}

/// Mixin for [BlocBase] (Cubits and Blocs) that provides resilient, guarded async operations.
///
/// Replaces legacy SafeActionCubit with:
/// - Explicit [Result<T>] returns (never ambiguous null).
/// - Central exception mapping via [ErrorMapper].
/// - Closed-state and cooperative cancellation via [ActionToken].
/// - Double-submit / re-entrancy prevention via action [key] (returning [Failure.duplicate]).
/// - Exponential backoff retry support for transient errors.
/// - Release-safe logging and unexpected error forwarding via [ActionGuardConfig.crashReporter].
mixin ActionGuard<S> on BlocBase<S> {
  final Set<String> _inFlightActionKeys = <String>{};

  /// Guards an async [action], catching all errors and returning a typed [Result<T>].
  ///
  /// [key]: Optional unique key. If provided and an action with this key is already
  /// running, the call is rejected returning [Failure.duplicate] to prevent double-submit.
  ///
  /// [token]: Optional [ActionToken] checked before execution, after completion,
  /// and between retry intervals. When cancelled, returns [Failure.cancelled].
  ///
  /// [retries]: Number of retry attempts for transient failures.
  /// Defaults to 0 (no retries).
  ///
  /// [retryDelay]: Initial delay before the first retry. Doubles on each attempt.
  ///
  /// [emitter]: Optional [Emitter] if called from inside a Bloc event handler.
  /// Checked for `emitter.isDone`.
  Future<Result<T>> guard<T>(
    Future<T> Function() action, {
    String? key,
    ActionToken? token,
    int retries = 0,
    Duration retryDelay = const Duration(milliseconds: 500),
    Emitter<S>? emitter,
    String? logTag,
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    final tag = logTag ?? runtimeType.toString();

    // Check cancellation before starting
    if (token?.isCancelled ?? false) {
      return const Result.failure(Failure.cancelled(code: 'CANCELLED'));
    }

    // Prevent duplicate concurrent execution of the same action
    if (key != null) {
      if (_inFlightActionKeys.contains(key)) {
        AppLogger.debug('Rejected duplicate action for key: $key', tag: tag);
        return const Result.failure(Failure.duplicate());
      }
      _inFlightActionKeys.add(key);
    }

    try {
      var attempt = 0;
      while (true) {
        if (isClosed || (emitter != null && emitter.isDone)) {
          return const Result.failure(Failure.cancelled(code: 'CLOSED'));
        }
        if (token?.isCancelled ?? false) {
          return const Result.failure(Failure.cancelled(code: 'CANCELLED'));
        }

        try {
          final data = await action();

          if (isClosed || (emitter != null && emitter.isDone)) {
            return const Result.failure(Failure.cancelled(code: 'CLOSED'));
          }
          if (token?.isCancelled ?? false) {
            return const Result.failure(Failure.cancelled(code: 'CANCELLED'));
          }

          onSuccess?.call(data);
          return Result.success(data);
        } on Object catch (error, stackTrace) {
          final failure = ErrorMapper.map(error, stackTrace);

          // Retry logic for transient failures
          if (attempt < retries && failure.isRetryable) {
            if (token?.isCancelled ?? false) {
              return const Result.failure(Failure.cancelled(code: 'CANCELLED'));
            }

            attempt++;
            final delay = retryDelay * (1 << (attempt - 1));
            AppLogger.warning(
              'Retry attempt $attempt/$retries for $tag after ${delay.inMilliseconds}ms',
              tag: tag,
            );
            await Future<void>.delayed(delay);

            if (token?.isCancelled ?? false) {
              return const Result.failure(Failure.cancelled(code: 'CANCELLED'));
            }
            continue;
          }

          _logAndReportFailure(failure, tag);

          if (!isClosed && (emitter == null || !emitter.isDone)) {
            onFailure?.call(failure);
          }

          return Result.failure(failure);
        }
      }
    } finally {
      if (key != null) {
        _inFlightActionKeys.remove(key);
      }
    }
  }

  void _logAndReportFailure(Failure failure, String tag) {
    if (failure is CancelledFailure) {
      AppLogger.debug('Action cancelled in $tag (${failure.code})', tag: tag);
      return;
    }

    if (failure is DuplicateFailure) {
      AppLogger.debug('Duplicate action rejected in $tag', tag: tag);
      return;
    }

    if (failure is UnknownFailure) {
      AppLogger.error(
        'Unexpected failure in $tag: ${failure.code}',
        tag: tag,
        error: failure.originalError,
        stackTrace: failure.stackTrace,
      );

      final reporter = ActionGuardConfig.crashReporter;
      if (reporter != null) {
        unawaited(
          reporter.recordError(
            failure.originalError ?? Exception(failure.code),
            failure.stackTrace,
            reason: 'Unknown failure in $tag',
          ),
        );
      }
    } else {
      AppLogger.warning(
        'Handled failure in $tag: ${failure.code}',
        tag: tag,
        error: failure.originalError,
        stackTrace: failure.stackTrace,
      );
    }
  }
}
