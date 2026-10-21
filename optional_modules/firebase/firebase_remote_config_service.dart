// Copy to lib/core/observability/firebase_remote_config_service.dart when firebase_remote_config is added.
/*
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/observability/remote_config_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IRemoteConfigService)
class FirebaseRemoteConfigService implements IRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: AppConfig.isDev ? Duration.zero : const Duration(hours: 1),
      ),
    );
    await _remoteConfig.setDefaults({
      'min_supported_version': AppConfig.minSupportedVersion,
      'maintenance_mode': AppConfig.maintenanceMode,
      'force_update_url': AppConfig.forceUpdateUrl,
    });
  }

  @override
  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  @override
  bool getBool(String key, {bool defaultValue = false}) =>
      _remoteConfig.getBool(key);

  @override
  String getString(String key, {String defaultValue = ''}) =>
      _remoteConfig.getString(key);

  @override
  int getInt(String key, {int defaultValue = 0}) =>
      _remoteConfig.getInt(key);

  @override
  double getDouble(String key, {double defaultValue = 0.0}) =>
      _remoteConfig.getDouble(key);
}
*/
