import 'package:flutter/material.dart';
import 'package:flutter_starter/core/cubit/connectivity_cubit.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.noInternetTitle)),
      body: Center(
        child: Padding(
          padding: AppSpacing.edgeInsetsAllXxl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: AppIconSize.xxl,
                color: theme.colorScheme.error,
              ),
              AppSpacing.gapHLg,
              Text(
                l10n.noInternetTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapHSm,
              Text(
                l10n.noInternetMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapHXxl,
              AppButton(
                label: l10n.tryAgain,
                icon: Icons.refresh_rounded,
                isExpanded: false,
                onPressed: () {
                  if (getIt.isRegistered<ConnectivityCubit>()) {
                    getIt<ConnectivityCubit>().refresh();
                  }
                  onRetry?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
