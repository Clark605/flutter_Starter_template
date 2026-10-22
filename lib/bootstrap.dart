import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_starter/app.dart';
import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/cubit/action_guard.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/core/errors/error_mapper.dart';
import 'package:flutter_starter/core/network/dio_error_mapper.dart';
import 'package:flutter_starter/core/observability/crash_reporter.dart';
import 'package:flutter_starter/core/observability/force_update_gate.dart';
import 'package:flutter_starter/core/observability/remote_config_service.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/storage/prefs_service.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

Future<void> bootstrap() async {
  final startupTimer = AppLogger.startTimer(
    'Bootstrap to First Frame',
    tag: 'Startup',
  );

  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Buffer errors that occur before ICrashReporter is fully initialized
  final preInitErrors =
      <({Object error, StackTrace? stack, String? reason, bool fatal})>[];
  var isCrashReporterReady = false;

  // Global Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'FlutterError: ${details.exceptionAsString()}',
      tag: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );

    if (isCrashReporterReady && getIt.isRegistered<ICrashReporter>()) {
      getIt<ICrashReporter>().recordError(
        details.exception,
        details.stack,
        reason: details.context?.toString(),
        fatal: false,
      );
    } else {
      preInitErrors.add((
        error: details.exception,
        stack: details.stack,
        reason: details.context?.toString(),
        fatal: false,
      ));
    }
  };

  // Global uncaught platform error handler
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      'PlatformDispatcher error: $error',
      tag: 'PlatformError',
      error: error,
      stackTrace: stack,
    );

    if (isCrashReporterReady && getIt.isRegistered<ICrashReporter>()) {
      getIt<ICrashReporter>().recordError(error, stack, fatal: true);
    } else {
      preInitErrors.add((
        error: error,
        stack: stack,
        reason: null,
        fatal: true,
      ));
    }
    return true;
  };

  String initialRoute = RouteNames.home;
  Object? initialRouteArgs;

  try {
    // 0. Register core transport error mappers
    ErrorMapper.register(mapDioException);

    // 1. Initialize dependency injection
    await configureDependencies();

    // 2. Initialize Crash Reporter and flush pre-initialization buffered errors
    if (getIt.isRegistered<ICrashReporter>()) {
      final crashReporter = getIt<ICrashReporter>();
      await crashReporter.init();
      isCrashReporterReady = true;
      ActionGuardConfig.crashReporter = crashReporter;

      for (final buffered in preInitErrors) {
        await crashReporter.recordError(
          buffered.error,
          buffered.stack,
          reason: buffered.reason,
          fatal: buffered.fatal,
        );
      }
      preInitErrors.clear();
    }

    // 3. Initialize Remote Config with timeout fallback
    if (getIt.isRegistered<IRemoteConfigService>()) {
      final remoteConfig = getIt<IRemoteConfigService>();
      try {
        await (() async {
          await remoteConfig.init();
          await remoteConfig.fetchAndActivate();
        })().timeout(AppConfig.remoteConfigTimeout);
      } on Object catch (e, st) {
        AppLogger.warning(
          'RemoteConfig initialization timed out or failed; falling back to default values.',
          tag: 'Startup',
          error: e,
          stackTrace: st,
        );
      }
    }

    // 4. Startup maintenance and version gate check
    final gate = getIt<ForceUpdateGate>();
    final gateResult = await gate.check();

    switch (gateResult.status) {
      case GateStatus.maintenance:
        initialRoute = RouteNames.maintenance;
      case GateStatus.updateRequired:
        initialRoute = RouteNames.updateRequired;
        initialRouteArgs = gateResult.updateUrl;
      case GateStatus.normal:
        final prefs = getIt<PrefsService>();
        if (!prefs.hasSeenOnboarding) {
          initialRoute = RouteNames.onboarding;
        } else {
          initialRoute = RouteNames.home;
        }
    }
  } on Object catch (e, st) {
    AppLogger.error(
      'Bootstrap initialization failed, falling back to safe error route: $e',
      tag: 'Startup',
      error: e,
      stackTrace: st,
    );
    if (isCrashReporterReady && getIt.isRegistered<ICrashReporter>()) {
      await getIt<ICrashReporter>().recordError(e, st, fatal: true);
    }
    initialRoute = RouteNames.error;
    initialRouteArgs = null;
  } finally {
    // 5. Always remove native splash screen to prevent UI deadlock
    FlutterNativeSplash.remove();
    startupTimer.stop(note: 'initial route: $initialRoute');
  }

  runApp(
    StarterApp(initialRoute: initialRoute, initialRouteArgs: initialRouteArgs),
  );
}
