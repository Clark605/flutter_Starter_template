import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color surfaceHigh;
  final Color border;

  const AppColorsExtension({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.surfaceHigh,
    required this.border,
  });

  static const AppColorsExtension light = AppColorsExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    surfaceHigh: AppColors.lightSurfaceHigh,
    border: AppColors.lightBorder,
  );

  static const AppColorsExtension dark = AppColorsExtension(
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    info: AppColors.info,
    surfaceHigh: AppColors.darkSurfaceHigh,
    border: AppColors.darkBorder,
  );

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? surfaceHigh,
    Color? border,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      surfaceHigh: surfaceHigh ?? this.surfaceHigh,
      border: border ?? this.border,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      error: Color.lerp(error, other.error, t) ?? error,
      info: Color.lerp(info, other.info, t) ?? info,
      surfaceHigh: Color.lerp(surfaceHigh, other.surfaceHigh, t) ?? surfaceHigh,
      border: Color.lerp(border, other.border, t) ?? border,
    );
  }
}

extension AppColorsExtensionContext on BuildContext {
  AppColorsExtension get appColors =>
      Theme.of(this).extension<AppColorsExtension>() ??
      AppColorsExtension.light;
}
