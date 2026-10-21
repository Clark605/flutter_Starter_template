import 'dart:async';
import 'package:flutter_starter/core/routes/app_navigator.dart';
import 'package:flutter_starter/core/routes/route_names.dart';
import 'package:flutter_starter/core/utils/app_logger.dart';

class DeepLinkService {
  Future<void> init() async {
    AppLogger.info('DeepLinkService initialized', tag: 'DeepLinks');
    // Using app_links:
    // final appLinks = AppLinks();
    // final uri = await appLinks.getInitialLink();
    // if (uri != null) handleUri(uri);
    // appLinks.uriLinkStream.listen(handleUri);
  }

  void handleUri(Uri uri) {
    AppLogger.info('Incoming deep link: $uri', tag: 'DeepLinks');
    final segments = uri.pathSegments;

    if (segments.isEmpty) {
      AppNavigator.pushNamed(RouteNames.home);
      return;
    }

    switch (segments.first) {
      case 'example':
      case 'item':
        if (segments.length > 1) {
          final id = int.tryParse(segments[1]) ?? 0;
          AppNavigator.pushNamed(RouteNames.exampleDetail, arguments: id);
        } else {
          AppNavigator.pushNamed(RouteNames.example);
        }
        break;
      case 'settings':
        AppNavigator.pushNamed(RouteNames.settings);
        break;
      default:
        AppNavigator.pushNamed(RouteNames.home);
        break;
    }
  }
}
