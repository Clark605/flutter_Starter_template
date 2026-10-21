import 'package:flutter/material.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class MaintenanceScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const MaintenanceScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.maintenanceTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.edgeInsetsAllXxl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction_rounded,
                  size: AppIconSize.xxl,
                  color: theme.colorScheme.tertiary,
                ),
                AppSpacing.gapHLg,
                Text(
                  l10n.maintenanceTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapHSm,
                Text(
                  l10n.maintenanceMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  AppSpacing.gapHXxl,
                  AppButton(
                    label: l10n.refresh,
                    icon: Icons.refresh_rounded,
                    isExpanded: false,
                    onPressed: onRetry,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
