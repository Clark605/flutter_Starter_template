import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/app_colors.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_radius.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final BorderRadius borderRadius;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.borderRadius = AppRadius.md,
    this.height = AppSpacing.huge, // 48px minimum touch target
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (bgColor, fgColor, borderColor) = switch (variant) {
      AppButtonVariant.primary => (
        colorScheme.primary,
        colorScheme.onPrimary,
        Colors.transparent,
      ),
      AppButtonVariant.secondary => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        Colors.transparent,
      ),
      AppButtonVariant.outline => (
        Colors.transparent,
        colorScheme.onSurface,
        colorScheme.outline,
      ),
      AppButtonVariant.text => (
        Colors.transparent,
        colorScheme.primary,
        Colors.transparent,
      ),
      AppButtonVariant.danger => (
        AppColors.error,
        AppColors.white,
        Colors.transparent,
      ),
    };

    final content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            height: AppIconSize.md,
            width: AppIconSize.md,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(fgColor),
            ),
          ),
          AppSpacing.gapWSm,
        ] else if (icon != null) ...[
          Icon(icon, size: AppIconSize.md, color: fgColor),
          AppSpacing.gapWSm,
        ],
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return SizedBox(
      height: height,
      width: isExpanded ? double.infinity : null,
      child: Material(
        color: onPressed == null && !isLoading
            ? colorScheme.onSurface.withValues(alpha: 0.12)
            : bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: borderColor != Colors.transparent
              ? BorderSide(color: borderColor)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Center(widthFactor: isExpanded ? null : 1.0, child: content),
          ),
        ),
      ),
    );
  }
}
