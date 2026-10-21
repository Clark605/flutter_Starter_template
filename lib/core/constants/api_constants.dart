import 'package:flutter_starter/core/config/app_config.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => AppConfig.baseUrl;

  // Example / Reference endpoints
  static const String items = '/posts';
  static String itemDetail(int id) => '/posts/$id';

  // Common auth endpoints (used by auth optional module or backend adapters)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
}
