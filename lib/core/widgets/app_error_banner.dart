import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';
import 'package:flutter_starter/core/theme/app_durations.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';

class AppErrorBanner extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onDismiss;

  const AppErrorBanner({super.key, required this.errorMessage, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return AnimatedSwitcher(
      duration: AppDurations.normal,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -0.5),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: hasError
          ? Container(
              key: ValueKey<String>(errorMessage!),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              decoration: const BoxDecoration(
                color: AppColors.error,
                borderRadius: AppRadius.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.white,
                    size: AppIconSize.md,
                  ),
                  AppSpacing.gapWSm,
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (onDismiss != null)
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.white,
                        size: AppIconSize.sm,
                      ),
                      onPressed: onDismiss,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
