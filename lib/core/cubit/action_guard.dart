import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/errors/result.dart';
import 'package:flutter_starter/core/observability/crash_reporter.dart';
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
/// Features:
/// - Explicit [Result<T>] returns.
/// - Central exception mapping via [ErrorMapper].
/// - Closed-state safety checks.
/// - Double-submit / re-entrancy prevention via action [key] (returning [Failure.duplicate]).
/// - Release-safe logging and unexpected error forwarding via [ActionGuardConfig.crashReporter].
mixin ActionGuard<S> on BlocBase<S> {
  final Set<String> _inFlightActionKeys = <String>{};

  bool _isInactive(Emitter<S>? emitter) =>
      isClosed || (emitter != null && emitter.isDone);

  /// Guards an async [action], catching all errors and returning a typed [Result<T>].
  ///
  /// [key]: Optional unique key. If provided and an action with this key is already
  /// running, the call is rejected returning [Failure.duplicate] to prevent double-submit.
  ///
  /// [emitter]: Optional [Emitter] if called from inside a Bloc event handler.
  Future<Result<T>> guard<T>(
    Future<T> Function() action, {
    String? key,
    Emitter<S>? emitter,
  }) async {
    final tag = runtimeType.toString();

    // Prevent duplicate concurrent execution of the same action
    if (key != null) {
      if (_inFlightActionKeys.contains(key)) {
        AppLogger.debug('Rejected duplicate action for key: $key', tag: tag);
        return const Result.failure(Failure.duplicate());
      }
      _inFlightActionKeys.add(key);
    }

    try {
      if (_isInactive(emitter)) {
        return const Result.failure(Failure.cancelled(code: 'CLOSED'));
      }

      try {
        final data = await action();

        if (_isInactive(emitter)) {
          return const Result.failure(Failure.cancelled(code: 'CLOSED'));
        }

        return Result.success(data);
      } on Object catch (error, stackTrace) {
        final failure = ErrorMapper.map(error, stackTrace);
        _logAndReportFailure(failure, tag);
        return Result.failure(failure);
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
