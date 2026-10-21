class RouteNames {
  RouteNames._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String example = '/example';
  static const String exampleDetail = '/example-detail';
  static const String noInternet = '/no-internet';
  static const String error = '/error';
  static const String maintenance = '/maintenance';
  static const String updateRequired = '/update-required';
  static const String notFound = '/404';

  /// Routes that require an authenticated user session.
  static const Set<String> protectedRoutes = {
    home,
    settings,
    example,
    exampleDetail,
  };
}
