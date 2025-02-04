
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class RootNavigatorObserver extends NavigatorObserver {
  int _routeCount = 0; // Track the number of routes in the stack

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _routeCount++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _routeCount--;

    // If only one route remains, close the app
    if (_routeCount == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SystemNavigator.pop();
      });
    }
  }
}