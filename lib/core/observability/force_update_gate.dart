import 'package:flutter_starter/core/config/app_config.dart';
import 'package:flutter_starter/core/observability/remote_config_service.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum GateStatus { normal, maintenance, updateRequired }

class GateCheckResult {
  final GateStatus status;
  final String updateUrl;

  const GateCheckResult({required this.status, this.updateUrl = ''});

  bool get isBlocked => status != GateStatus.normal;
}

@lazySingleton
class ForceUpdateGate {
  final IRemoteConfigService _remoteConfig;

  ForceUpdateGate(this._remoteConfig);

  Future<GateCheckResult> check() async {
    try {
      final isMaintenance = _remoteConfig.getBool(
        'maintenance_mode',
        defaultValue: AppConfig.maintenanceMode,
      );
      if (isMaintenance) {
        return const GateCheckResult(status: GateStatus.maintenance);
      }

      final minVersion = _remoteConfig.getString(
        'min_supported_version',
        defaultValue: AppConfig.minSupportedVersion,
      );

      final updateUrl = _remoteConfig.getString(
        'force_update_url',
        defaultValue: AppConfig.forceUpdateUrl,
      );

      if (minVersion.isNotEmpty) {
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;

        if (_isVersionBelow(currentVersion, minVersion)) {
          return GateCheckResult(
            status: GateStatus.updateRequired,
            updateUrl: updateUrl,
          );
        }
      }

      return const GateCheckResult(status: GateStatus.normal);
    } on Object catch (e, st) {
      AppLogger.warning(
        'ForceUpdateGate check failed, allowing normal launch',
        tag: 'ForceUpdateGate',
        error: e,
        stackTrace: st,
      );
      return const GateCheckResult(status: GateStatus.normal);
    }
  }

  bool _isVersionBelow(String current, String required) {
    final currentParts = current
        .split('+')
        .first
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
    final requiredParts = required
        .split('+')
        .first
        .split('.')
        .map((p) => int.tryParse(p) ?? 0)
        .toList();

    while (currentParts.length < 3) {
      currentParts.add(0);
    }
    while (requiredParts.length < 3) {
      requiredParts.add(0);
    }

    for (var i = 0; i < 3; i++) {
      if (currentParts[i] < requiredParts[i]) return true;
      if (currentParts[i] > requiredParts[i]) return false;
    }
    return false;
  }
}
