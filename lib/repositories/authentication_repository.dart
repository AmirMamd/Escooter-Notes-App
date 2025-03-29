import 'package:appwrite/appwrite.dart';

import '../services/app_write_service.dart';

class AuthenticationRepository {
  final AppwriteService _appwriteService;

  AuthenticationRepository(this._appwriteService);

  Future<void> login(String email, String password) async {
    try {
      final session = await _appwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      await _appwriteService.storeSession(session.secret);
    } on AppwriteException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  Future<void> createAccount(String email, String password, String name) async {
    try {
      await _appwriteService.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      await login(email, password);
    } on AppwriteException catch (e) {
      throw e.message ?? 'Account creation failed';
    }
  }

  Future<void> logout() async {
    try {
      await _appwriteService.account.deleteSession(sessionId: 'current');
      await _appwriteService.clearSession();
    } on AppwriteException catch (e) {
      throw e.message ?? 'Logout failed';
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final session = await _appwriteService.getCurrentSession();
      return session != null;
    } catch (e) {
      return false;
    }
  }
}