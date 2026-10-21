import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final String? ctaText;
  final VoidCallback? onCtaPressed;

  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.ctaText,
    this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: AppSpacing.edgeInsetsAllXxl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppIconSize.xxl,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            AppSpacing.gapHLg,
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null && description!.isNotEmpty) ...[
              AppSpacing.gapHSm,
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (ctaText != null && onCtaPressed != null) ...[
              AppSpacing.gapHXl,
              AppButton(
                label: ctaText!,
                onPressed: onCtaPressed,
                isExpanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
