import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings_state.freezed.dart';

@freezed
abstract class AppSettingsState with _$AppSettingsState {
  const factory AppSettingsState({
    required ThemeMode themeMode,
    required Locale locale,
    @Default('1.0.0') String appVersion,
    @Default('1') String buildNumber,
  }) = _AppSettingsState;
}
