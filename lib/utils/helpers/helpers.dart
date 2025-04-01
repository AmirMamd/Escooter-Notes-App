import 'dart:math';

import 'package:flutter/services.dart';

class Helpers {
  static void setOrientationToPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static String generateHexId({int length = 20}) {
    const chars = '0123456789abcdef';
    final rand = Random.secure();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)])
        .join();
  }
}

abstract class Enum<T> {
  final T _value;

  const Enum(this._value);

  T get value => _value;
}
