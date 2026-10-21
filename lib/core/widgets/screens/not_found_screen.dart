import 'package:flutter/material.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class NotFoundScreen extends StatelessWidget {
  final String? routeName;

  const NotFoundScreen({super.key, this.routeName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notFoundRouteTitle)),
      body: Center(
        child: Padding(
          padding: AppSpacing.edgeInsetsAllXxl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: AppIconSize.xxl,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              AppSpacing.gapHLg,
              Text(
                '404',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.gapHSm,
              Text(
                l10n.notFoundRouteTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapHSm,
              Text(
                routeName != null
                    ? '${l10n.notFoundRouteMessage}\n($routeName)'
                    : l10n.notFoundRouteMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapHXxl,
              AppButton(
                label: l10n.goToHome,
                icon: Icons.home_rounded,
                isExpanded: false,
                onPressed: () {
                  AppNavigator.pushNamedAndRemoveUntil(
                    RouteNames.home,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
