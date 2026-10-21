import 'package:flutter_starter/core/utils/app_logger.dart';
import 'package:injectable/injectable.dart';

abstract interface class IAnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> setCurrentScreen(String screenName);
}

@LazySingleton(as: IAnalyticsService)
class NoOpAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    AppLogger.debug(
      'Analytics event "$name" with parameters: $parameters',
      tag: 'Analytics',
    );
  }

  @override
  Future<void> setUserId(String? userId) async {
    AppLogger.debug('Analytics userId: $userId', tag: 'Analytics');
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    AppLogger.debug('Analytics user property $name: $value', tag: 'Analytics');
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    AppLogger.debug('Analytics screen: $screenName', tag: 'Analytics');
  }
}
