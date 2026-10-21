import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  Color? textColor,
  SnackBarAction? action,
}) {
  context.showSnackBar(
    message,
    backgroundColor: backgroundColor,
    textColor: textColor,
    action: action,
  );
}

void showAppSuccessSnackBar(BuildContext context, String message) {
  context.showSuccessSnackBar(message);
}

void showAppErrorSnackBar(BuildContext context, String message) {
  context.showErrorSnackBar(message);
}

void showAppInfoSnackBar(BuildContext context, String message) {
  context.showInfoSnackBar(message);
}

extension AppSnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
    );
  }

  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
    );
  }

  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.info,
      textColor: AppColors.white,
    );
  }

  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    final theme = Theme.of(this);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHigh;
    final fg = textColor ?? theme.colorScheme.onSurface;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(color: fg),
        ),
        backgroundColor: bg,
        action: action,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
    );
  }
}
