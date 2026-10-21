import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';
import 'package:flutter_starter/core/theme/app_colors_extension.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_typography.dart';

ThemeData buildDarkTheme([Locale? locale]) {
  final fontFamily = AppTypography.fontFamilyFor(locale);
  final fontFallback = AppTypography.fallbackFor(locale);

  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primarySeed,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
      ).copyWith(
        primary: AppColors.primarySeed,
        onPrimary: AppColors.white,
        secondary: AppColors.secondarySeed,
        onSecondary: AppColors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        error: AppColors.error,
        onError: AppColors.white,
      );

  return ThemeData(
    useMaterial3: true,
    extensions: const [AppColorsExtension.dark],
    brightness: Brightness.dark,
    fontFamily: fontFamily,
    fontFamilyFallback: fontFallback,
    scaffoldBackgroundColor: AppColors.darkBackground,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    textTheme: AppTypography.getTextTheme(locale).apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    ),
    colorScheme: colorScheme,
    cardTheme: const CardThemeData(
      color: AppColors.darkSurfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.md,
        side: BorderSide(color: AppColors.darkBorder, width: 1),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceContainer,
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: BorderSide(color: AppColors.primarySeed, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primarySeed,
        foregroundColor: AppColors.white,
        elevation: 0,
        minimumSize: const Size(64, 48),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        textStyle: AppTypography.getTextTheme(
          locale,
        ).labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        minimumSize: const Size(64, 48),
        side: const BorderSide(color: AppColors.darkBorder),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        textStyle: AppTypography.getTextTheme(
          locale,
        ).labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primarySeed,
        minimumSize: const Size(48, 48),
        textStyle: AppTypography.getTextTheme(
          locale,
        ).labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.darkSurfaceHigh,
      contentTextStyle: TextStyle(color: AppColors.darkTextPrimary),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
      titleTextStyle: AppTypography.getTextTheme(locale).titleLarge?.copyWith(
        color: AppColors.darkTextPrimary,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: AppTypography.getTextTheme(
        locale,
      ).bodyLarge?.copyWith(color: AppColors.darkTextSecondary),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topXl),
    ),
  );
}
