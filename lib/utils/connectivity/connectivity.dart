import 'dart:io';

import 'package:escooter_notes_app/managers/caching/cashing_key.dart';
import 'package:escooter_notes_app/managers/caching/security.dart';

abstract class ConnectivityChecker {
  Future<bool> hasInternet();
}

class DefaultConnectivityChecker implements ConnectivityChecker {
  final SecureStorageInterface _secureStorage;

  DefaultConnectivityChecker(this._secureStorage);

  @override
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('cloud.appwrite.io');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _secureStorage.writeSecureData(CachingKey.CONNECTION.value, "false");
      return false;
    }
  }
}
