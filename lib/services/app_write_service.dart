import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/config/config.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases databases;
  late Storage storage;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AppwriteService() {
    client = Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);

    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
  }

  // Helper method to get current session
  Future<Session?> getCurrentSession() async {
    try {
      return await account.getSession(sessionId: 'current');
    } catch (e) {
      return null;
    }
  }

  // Store session token securely
  Future<void> storeSession(String jwt) async {
    await _secureStorage.write(key: 'appwrite_jwt', value: jwt);
    client.setJWT(jwt);
  }

  // Clear session on logout
  Future<void> clearSession() async {
    await _secureStorage.delete(key: 'appwrite_jwt');
    client.setJWT(null);
  }
}