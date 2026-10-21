import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/cubit/app_settings_cubit.dart';
import 'package:flutter_starter/core/cubit/app_settings_state.dart';
import 'package:flutter_starter/core/cubit/connectivity_cubit.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/core/network/auth_interceptor.dart';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/app_router.dart';
import 'package:flutter_starter/core/theme/app_theme.dart';
import 'package:flutter_starter/core/widgets/app_snackbar.dart';
import 'package:flutter_starter/core/widgets/offline_banner.dart';
import 'package:flutter_starter/l10n/generated/app_localizations.dart';

class StarterApp extends StatefulWidget {
  final String initialRoute;

  const StarterApp({super.key, required this.initialRoute});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  StreamSubscription<void>? _sessionExpiredSubscription;

  @override
  void initState() {
    super.initState();
    _sessionExpiredSubscription = AuthInterceptor.onSessionExpired.listen((_) {
      final context = AppNavigator.currentContext;
      if (context != null && context.mounted) {
        context.showErrorSnackBar('Session expired. Please log in again.');
      }
    });
  }

  @override
  void dispose() {
    _sessionExpiredSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsCubit>.value(value: getIt<AppSettingsCubit>()),
        BlocProvider<ConnectivityCubit>.value(
          value: getIt<ConnectivityCubit>(),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: AppNavigator.navigatorKey,
            themeMode: state.themeMode,
            theme: AppTheme.light(state.locale),
            darkTheme: AppTheme.dark(state.locale),
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: widget.initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
            builder: (context, child) {
              return OfflineBanner(child: child ?? const SizedBox.shrink());
            },
          );
        },
      ),
    );
  }
}
