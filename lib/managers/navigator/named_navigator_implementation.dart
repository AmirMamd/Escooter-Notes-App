import 'package:escooter_notes_app/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'named_navigator.dart';

class NamedNavigatorImpl implements NamedNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.LOGIN_SCREEN:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Login(),
        );

    }
    return MaterialPageRoute(settings: settings, builder: (_) => Container());
  }

  @override
  void pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  @override
  Future push(String routeName, {arguments, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    }
    return navigatorState.currentState!
        .pushNamed(routeName, arguments: arguments);
  }
}
