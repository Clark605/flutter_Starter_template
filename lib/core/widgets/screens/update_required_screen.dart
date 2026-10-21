import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_icon_size.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';
import 'package:flutter_starter/core/widgets/app_button.dart';
import 'package:flutter_starter/core/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateRequiredScreen extends StatelessWidget {
  final String? updateUrl;

  const UpdateRequiredScreen({super.key, this.updateUrl});

  String get _effectiveUrl => (updateUrl != null && updateUrl!.isNotEmpty)
      ? updateUrl!
      : AppConfig.forceUpdateUrl;

  Future<void> _openUpdateUrl(BuildContext context) async {
    final url = _effectiveUrl;
    if (url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && context.mounted) {
          _copyToClipboard(context);
        }
      } on Object catch (e, st) {
        AppLogger.error(
          'Failed to launch update URL: $url',
          tag: 'UpdateGate',
          error: e,
          stackTrace: st,
        );
        if (context.mounted) {
          _copyToClipboard(context);
        }
      }
    } else {
      if (context.mounted) {
        _copyToClipboard(context);
      }
    }
  }

  void _copyToClipboard(BuildContext context) {
    final url = _effectiveUrl;
    if (url.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: url));
      context.showInfoSnackBar(context.l10n.linkCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.updateRequiredTitle),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.edgeInsetsAllXxl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.system_update_rounded,
                  size: AppIconSize.xxl,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.gapHLg,
                Text(
                  l10n.updateRequiredTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapHSm,
                Text(
                  l10n.updateRequiredMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_effectiveUrl.isNotEmpty) ...[
                  AppSpacing.gapHXxl,
                  AppButton(
                    label: l10n.updateNow,
                    icon: Icons.open_in_new_rounded,
                    isExpanded: false,
                    onPressed: () => _openUpdateUrl(context),
                  ),
                  AppSpacing.gapHSm,
                  AppButton(
                    label: l10n.copyUpdateLink,
                    variant: AppButtonVariant.text,
                    isExpanded: false,
                    onPressed: () => _copyToClipboard(context),
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
