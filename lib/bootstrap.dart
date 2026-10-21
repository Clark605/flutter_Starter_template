import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_starter/app.dart';
import 'package:flutter_starter/core/di/injection.dart';
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

  // Global Flutter error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.error(
      'FlutterError: ${details.exceptionAsString()}',
      tag: 'FlutterError',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (getIt.isRegistered<ICrashReporter>()) {
      getIt<ICrashReporter>().recordError(
        details.exception,
        details.stack,
        reason: details.context?.toString(),
        fatal: false,
      );
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
    if (getIt.isRegistered<ICrashReporter>()) {
      getIt<ICrashReporter>().recordError(error, stack, fatal: true);
    }
    return true;
  };

  // Initialize dependency injection
  await configureDependencies();

  // Initialize observability services
  final crashReporter = getIt<ICrashReporter>();
  await crashReporter.init();

  final remoteConfig = getIt<IRemoteConfigService>();
  await remoteConfig.init();
  await remoteConfig.fetchAndActivate();

  // Startup maintenance and version gate check
  final gate = getIt<ForceUpdateGate>();
  final gateResult = await gate.check();

  final prefs = getIt<PrefsService>();
  final String initialRoute;

  if (gateResult.status == GateStatus.maintenance) {
    initialRoute = RouteNames.noInternet; // Or maintenance screen
  } else if (!prefs.hasSeenOnboarding) {
    initialRoute = RouteNames.onboarding;
  } else {
    initialRoute = RouteNames.home;
  }

  // Release native splash
  FlutterNativeSplash.remove();
  startupTimer.stop(note: 'initial route: $initialRoute');

  runApp(StarterApp(initialRoute: initialRoute));
}
