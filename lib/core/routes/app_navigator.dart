import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static NavigatorState? get currentState => navigatorKey.currentState;

  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?>? pushReplacementNamed<
    T extends Object?,
    TO extends Object?
  >(String routeName, {TO? result, Object? arguments}) {
    return currentState?.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  static Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return currentState?.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    currentState?.pop<T>(result);
  }

  static bool canPop() => currentState?.canPop() ?? false;

  static void resetKeyForTesting() {
    navigatorKey = GlobalKey<NavigatorState>();
  }
}
