import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/app_settings_cubit.dart';
import 'package:flutter_starter/core/cubit/app_settings_state.dart';
import 'package:flutter_starter/core/l10n/l10n_extension.dart';
import 'package:flutter_starter/core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          final cubit = context.read<AppSettingsCubit>();

          return ListView(
            padding: AppSpacing.edgeInsetsPage,
            children: [
              // Theme Mode Section
              Text(
                l10n.themeMode,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapHSm,
              Card(
                child: RadioGroup<ThemeMode>(
                  groupValue: state.themeMode,
                  onChanged: (mode) {
                    if (mode != null) cubit.setThemeMode(mode);
                  },
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text(l10n.themeSystem),
                        secondary: const Icon(Icons.brightness_auto_rounded),
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text(l10n.themeLight),
                        secondary: const Icon(Icons.light_mode_rounded),
                      ),
                      const Divider(height: 1),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text(l10n.themeDark),
                        secondary: const Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapHXl,

              // Language Section
              Text(
                l10n.language,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapHSm,
              Card(
                child: RadioGroup<String>(
                  groupValue: state.locale.languageCode,
                  onChanged: (code) {
                    if (code != null) cubit.setLocale(Locale(code));
                  },
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'en',
                        title: Text(l10n.english),
                        secondary: const Text(
                          '🇺🇸',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'ar',
                        title: Text(l10n.arabic),
                        secondary: const Text(
                          '🇸🇦',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapHXl,

              // About Section
              Text(
                l10n.about,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSpacing.gapHSm,
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: Text(l10n.appVersion),
                      trailing: Text(
                        'v${state.appVersion} (${state.buildNumber})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
