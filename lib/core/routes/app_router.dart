import 'package:flutter/material.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/routes/route_providers.dart';

/// Pluggable redirect interface for navigation guards.
abstract interface class IAuthRedirect {
  /// Returns a redirect route (e.g. `RouteNames.onboarding` or `/login`),
  /// or `null` if navigation to [routeName] should proceed normally.
  String? redirect(String? routeName);
}

/// Default no-op implementation of [IAuthRedirect] allowing all navigation.
class DefaultAuthRedirect implements IAuthRedirect {
  const DefaultAuthRedirect();

  @override
  String? redirect(String? routeName) => null;
}

class AppRouter {
  AppRouter._();

  /// Pluggable hook to intercept and redirect routes based on authentication/onboarding state.
  static IAuthRedirect authRedirect = const DefaultAuthRedirect();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final destination = authRedirect.redirect(settings.name) ?? settings.name;

    switch (destination) {
      case RouteNames.splash:
        return _fadeRoute(buildSplashRoute(), settings);

      case RouteNames.onboarding:
        return _fadeRoute(buildOnboardingRoute(), settings);

      case RouteNames.initial:
      case RouteNames.home:
      case RouteNames.example:
        return _fadeRoute(buildExampleRoute(), settings);

      case RouteNames.exampleDetail:
        return MaterialPageRoute(
          builder: (_) => buildExampleDetailRoute(settings.arguments),
          settings: settings,
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => buildSettingsRoute(),
          settings: settings,
        );

      case RouteNames.noInternet:
        return MaterialPageRoute(
          builder: (_) => buildNoInternetRoute(),
          settings: settings,
        );

      case RouteNames.maintenance:
        return MaterialPageRoute(
          builder: (_) => buildMaintenanceRoute(),
          settings: settings,
        );

      case RouteNames.updateRequired:
        final updateUrl = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => buildUpdateRequiredRoute(updateUrl),
          settings: settings,
        );

      case RouteNames.error:
        final message = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => buildErrorRoute(message: message),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => buildNotFoundRoute(settings.name),
          settings: settings,
        );
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
