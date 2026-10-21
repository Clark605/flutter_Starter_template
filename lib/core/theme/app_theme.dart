import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/dark_theme.dart';
import 'package:flutter_starter/core/theme/light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light([Locale? locale]) => buildLightTheme(locale);
  static ThemeData dark([Locale? locale]) => buildDarkTheme(locale);
}
