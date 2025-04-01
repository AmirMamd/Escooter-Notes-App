import 'dart:io';

abstract class ConnectivityChecker {
  Future<bool> hasInternet();
}

class DefaultConnectivityChecker implements ConnectivityChecker {
  @override
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('cloud.appwrite.io');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
