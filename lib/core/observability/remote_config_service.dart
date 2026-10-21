import 'package:flutter_starter/core/config/app_config.dart';
import 'package:injectable/injectable.dart';

abstract interface class IRemoteConfigService {
  Future<void> init();
  Future<void> fetchAndActivate();
  bool getBool(String key, {bool defaultValue = false});
  String getString(String key, {String defaultValue = ''});
  int getInt(String key, {int defaultValue = 0});
  double getDouble(String key, {double defaultValue = 0.0});
}

@LazySingleton(as: IRemoteConfigService)
class NoOpRemoteConfigService implements IRemoteConfigService {
  final Map<String, dynamic> _defaults = {
    'min_supported_version': AppConfig.minSupportedVersion,
    'maintenance_mode': AppConfig.maintenanceMode,
    'force_update_url': AppConfig.forceUpdateUrl,
  };

  @override
  Future<void> init() async {}

  @override
  Future<void> fetchAndActivate() async {}

  @override
  bool getBool(String key, {bool defaultValue = false}) {
    final value = _defaults[key];
    if (value is bool) return value;
    return defaultValue;
  }

  @override
  String getString(String key, {String defaultValue = ''}) {
    final value = _defaults[key];
    if (value != null) return value.toString();
    return defaultValue;
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    final value = _defaults[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  @override
  double getDouble(String key, {double defaultValue = 0.0}) {
    final value = _defaults[key];
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }
}
