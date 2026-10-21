import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/widgets/screens/error_screen.dart';
import 'package:flutter_starter/core/widgets/screens/no_internet_screen.dart';
import 'package:flutter_starter/core/widgets/screens/not_found_screen.dart';
import 'package:flutter_starter/core/widgets/screens/onboarding_screen.dart';
import 'package:flutter_starter/core/widgets/screens/settings_screen.dart';
import 'package:flutter_starter/core/widgets/screens/splash_screen.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_bloc.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/cubit/example_cubit.dart';
import 'package:flutter_starter/features/example/ui/example_detail_screen.dart';
import 'package:flutter_starter/features/example/ui/example_screen.dart';

Widget buildSplashRoute() => const SplashScreen();

Widget buildOnboardingRoute() => const OnboardingScreen();

Widget buildSettingsRoute() => const SettingsScreen();

Widget buildNotFoundRoute(String? routeName) =>
    NotFoundScreen(routeName: routeName);

Widget buildNoInternetRoute([VoidCallback? onRetry]) =>
    NoInternetScreen(onRetry: onRetry);

Widget buildErrorRoute({
  Failure? failure,
  String? message,
  VoidCallback? onRetry,
}) => ErrorScreen(failure: failure, errorMessage: message, onRetry: onRetry);

Widget buildExampleRoute() => BlocProvider(
  create: (_) => getIt<ExampleCubit>()..loadItems(),
  child: const ExampleScreen(),
);

Widget buildExampleDetailRoute(int id) => BlocProvider(
  create: (_) => getIt<ExampleDetailBloc>()..add(ExampleDetailEvent.load(id)),
  child: ExampleDetailScreen(itemId: id),
);
