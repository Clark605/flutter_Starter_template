enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor fromString(String value) {
    return switch (value.toLowerCase().trim()) {
      'dev' || 'development' => AppFlavor.dev,
      'staging' => AppFlavor.staging,
      'prod' || 'production' => AppFlavor.prod,
      _ => AppFlavor.dev,
    };
  }
}

class AppConfig {
  AppConfig._();

  static const String _flavorStr = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Flutter Starter',
  );
  static const String applicationId = String.fromEnvironment(
    'APPLICATION_ID',
    defaultValue: 'com.starter.flutter_starter',
  );
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );
  static const int connectTimeoutSeconds = int.fromEnvironment(
    'CONNECT_TIMEOUT_SECONDS',
    defaultValue: 30,
  );
  static const int receiveTimeoutSeconds = int.fromEnvironment(
    'RECEIVE_TIMEOUT_SECONDS',
    defaultValue: 30,
  );
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );
  static const String minSupportedVersion = String.fromEnvironment(
    'MIN_SUPPORTED_VERSION',
    defaultValue: '1.0.0',
  );
  static const bool maintenanceMode = bool.fromEnvironment(
    'MAINTENANCE_MODE',
    defaultValue: false,
  );
  static const String forceUpdateUrl = String.fromEnvironment(
    'FORCE_UPDATE_URL',
    defaultValue: '',
  );

  static final AppFlavor flavor = AppFlavor.fromString(_flavorStr);

  static bool get isDev => flavor == AppFlavor.dev;
  static bool get isStaging => flavor == AppFlavor.staging;
  static bool get isProd => flavor == AppFlavor.prod;

  static Duration get connectTimeout =>
      const Duration(seconds: connectTimeoutSeconds);
  static Duration get receiveTimeout =>
      const Duration(seconds: receiveTimeoutSeconds);
}
