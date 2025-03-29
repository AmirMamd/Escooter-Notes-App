class Routes {
  static const LOGIN_SCREEN = "LOGIN_SCREEN";
}

abstract class NamedNavigator {
  Future push(String routeName, {dynamic arguments, bool clean = false});

  void pop({dynamic result});
}

class RedirectionRoute {
  final String name;
  final dynamic arguments;

  RedirectionRoute({required this.name, this.arguments});

  @override
  String toString() {
    return '''RedirectionRoute(name: $name, arguments: $arguments)''';
  }
}
