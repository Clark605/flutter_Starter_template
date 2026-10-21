import 'package:flutter/material.dart';
import 'package:flutter_starter/core/constants/storage_keys.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PrefsService {
  final SharedPreferences _prefs;

  PrefsService(this._prefs);

  ThemeMode getThemeMode() {
    final value = _prefs.getString(StorageKeys.themeMode);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(StorageKeys.themeMode, mode.name);

  String getLocaleCode() => _prefs.getString(StorageKeys.locale) ?? 'en';

  Future<void> setLocaleCode(String code) =>
      _prefs.setString(StorageKeys.locale, code);

  bool get hasSeenOnboarding =>
      _prefs.getBool(StorageKeys.hasSeenOnboarding) ?? false;

  Future<void> setHasSeenOnboarding(bool seen) =>
      _prefs.setBool(StorageKeys.hasSeenOnboarding, seen);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  Future<void> clearAll() => _prefs.clear();
}

@module
abstract class PrefsModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
