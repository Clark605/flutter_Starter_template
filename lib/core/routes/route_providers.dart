import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/storage/prefs_service.dart';
import 'package:flutter_starter/core/widgets/screens/error_screen.dart';
import 'package:flutter_starter/core/widgets/screens/maintenance_screen.dart';
import 'package:flutter_starter/core/widgets/screens/no_internet_screen.dart';
import 'package:flutter_starter/core/widgets/screens/not_found_screen.dart';
import 'package:flutter_starter/core/widgets/screens/onboarding_screen.dart';
import 'package:flutter_starter/core/widgets/screens/settings_screen.dart';
import 'package:flutter_starter/core/widgets/screens/splash_screen.dart';
import 'package:flutter_starter/core/widgets/screens/update_required_screen.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_bloc.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/cubit/example_cubit.dart';
import 'package:flutter_starter/features/example/ui/example_detail_args.dart';
import 'package:flutter_starter/features/example/ui/example_detail_screen.dart';
import 'package:flutter_starter/features/example/ui/example_screen.dart';

Widget buildSplashRoute() => const SplashScreen();

Widget buildOnboardingRoute() => OnboardingScreen(
  onComplete: () async {
    final prefs = getIt<PrefsService>();
    await prefs.setHasSeenOnboarding(true);
    await AppNavigator.pushReplacementNamed(RouteNames.home);
  },
);

Widget buildSettingsRoute() => const SettingsScreen();

Widget buildNotFoundRoute(String? routeName) =>
    NotFoundScreen(routeName: routeName);

Widget buildNoInternetRoute([VoidCallback? onRetry]) =>
    NoInternetScreen(onRetry: onRetry);

Widget buildMaintenanceRoute([VoidCallback? onRetry]) =>
    MaintenanceScreen(onRetry: onRetry);

Widget buildUpdateRequiredRoute([String updateUrl = '']) =>
    UpdateRequiredScreen(updateUrl: updateUrl);

Widget buildErrorRoute({
  Failure? failure,
  String? message,
  VoidCallback? onRetry,
}) => ErrorScreen(failure: failure, errorMessage: message, onRetry: onRetry);

Widget buildExampleRoute() => BlocProvider(
  create: (_) => getIt<ExampleCubit>()..loadItems(),
  child: const ExampleScreen(),
);

Widget buildExampleDetailRoute(Object? arguments) {
  final int? itemId = switch (arguments) {
    final ExampleDetailArgs detailArgs => detailArgs.itemId,
    final int id => id,
    final String str => int.tryParse(str),
    final Map<String, dynamic> map =>
      (map['id'] as int?) ?? (map['itemId'] as int?),
    _ => null,
  };

  if (itemId == null || itemId <= 0) {
    return buildNotFoundRoute(RouteNames.exampleDetail);
  }

  return BlocProvider(
    create: (_) =>
        getIt<ExampleDetailBloc>()..add(ExampleDetailEvent.load(itemId)),
    child: ExampleDetailScreen(itemId: itemId),
  );
}
