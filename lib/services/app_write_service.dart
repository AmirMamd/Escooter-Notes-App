import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/data/security.dart';
import 'package:escooter_notes_app/managers/caching/cashing_key.dart';

import '../utils/config/config.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases databases;
  late Storage storage;

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
  Future<void> storeSession(Jwt token) async {
    await SecureStorage()
        .writeSecureData(CachingKey.ACCESS_TOKEN.value, token.jwt);
    client.setJWT(token.jwt);
  }

  // Clear session on logout
  Future<void> clearSession() async {
    await SecureStorage().deleteSecureData(CachingKey.ACCESS_TOKEN.value);
    client.setJWT(null);
  }
}
