// Copy to lib/core/services/push_notification_service.dart when firebase_messaging is installed.
import 'dart:async';
import 'package:flutter_starter/core/utils/app_logger.dart';

abstract interface class IPushNotificationService {
  Future<void> init();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
}

class PushNotificationService implements IPushNotificationService {
  final StreamController<String> _tokenController =
      StreamController<String>.broadcast();

  @override
  Stream<String> get onTokenRefresh => _tokenController.stream;

  @override
  Future<void> init() async {
    AppLogger.info('PushNotificationService initialized', tag: 'Notifications');
    // 1. Request notification permissions:
    // final settings = await FirebaseMessaging.instance.requestPermission();
    //
    // 2. Initialize flutter_local_notifications plugin for Android heads-up alerts
    //
    // 3. Listen to foreground messages:
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) { ... });
  }

  @override
  Future<String?> getToken() async {
    // return await FirebaseMessaging.instance.getToken();
    return null;
  }
}
