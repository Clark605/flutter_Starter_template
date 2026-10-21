import 'package:flutter/material.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class AppErrorState extends StatelessWidget {
  final Failure? failure;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.failure,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final displayMessage =
        failure?.localizedMessage(context) ?? errorMessage ?? l10n.errorUnknown;

    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsAllXxl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: AppIconSize.xxl,
              color: AppColors.error,
            ),
            AppSpacing.gapHLg,
            Text(
              l10n.error,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapHSm,
            Text(
              displayMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapHXl,
              AppButton(
                label: l10n.retry,
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
                isExpanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
