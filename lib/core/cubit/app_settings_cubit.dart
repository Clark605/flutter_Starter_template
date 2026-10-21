import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/app_settings_state.dart';
import 'package:flutter_starter/core/storage/prefs_service.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@lazySingleton
class AppSettingsCubit extends Cubit<AppSettingsState> {
  final PrefsService _prefs;

  AppSettingsCubit(this._prefs)
    : super(
        AppSettingsState(
          themeMode: _prefs.getThemeMode(),
          locale: Locale(_prefs.getLocaleCode()),
        ),
      ) {
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      emit(
        state.copyWith(appVersion: info.version, buildNumber: info.buildNumber),
      );
    } on Object catch (_) {
      // Fallback kept from initial state
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setLocaleCode(locale.languageCode);
    emit(state.copyWith(locale: locale));
  }

  Future<void> toggleThemeMode() async {
    final nextMode = switch (state.themeMode) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.system,
      ThemeMode.system => ThemeMode.dark,
    };
    await setThemeMode(nextMode);
  }
}
