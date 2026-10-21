// Copy to lib/core/observability/firebase_analytics_service.dart when firebase_analytics is added.
/*
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_starter/core/observability/analytics_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAnalyticsService)
class FirebaseAnalyticsService implements IAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters?.cast<String, Object>());
  }

  @override
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }
}
*/
