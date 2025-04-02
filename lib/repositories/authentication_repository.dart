import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/managers/caching/cashing_key.dart';
import 'package:escooter_notes_app/managers/caching/security.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/services/email_service.dart';
import 'package:escooter_notes_app/services/user_service.dart';

import '../services/app_write_service.dart';
import '../utils/config/config.dart';

class AuthenticationRepository {
  final AppwriteService _appwriteService;
  final UserService _userService;
  final EmailService _emailService;
  final SecureStorageInterface _secureStorage;

  AuthenticationRepository(this._appwriteService, this._emailService,
      this._secureStorage, this._userService);

  Future<void> login(String email, String password) async {
    try {
      final loggedIn = await isLoggedIn();
      if (loggedIn) {
        NamedNavigatorImpl().push(Routes.NOTES_SCREEN);
      }
    } catch (_) {
      throw Exception("No Valid Session");
    }

    try {
      await _appwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await _appwriteService.account.get();

      if (user.emailVerification) {
        final token = await _appwriteService.account.createJWT();
        await _appwriteService.storeSession(token);
      } else {
        throw 'Please verify your email before logging in.';
      }
    } on AppwriteException catch (e) {
      throw e.message ?? 'Login failed';
    }
  }

  Future<User> createAccount(
      String email, String password, String name, String phone) async {
    try {
      final user = await _appwriteService.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      await _appwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      await _appwriteService.account
          .updatePhone(phone: phone, password: password);

      return user;
    } on AppwriteException catch (e) {
      throw e.message ?? 'Account creation failed';
    }
  }

  Future<User> getCurrentUser() async {
    try {
      return await _appwriteService.account.get();
    } on AppwriteException catch (e) {
      throw e.message ?? 'Failed to get user';
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
      final session =
          await _appwriteService.account.getSession(sessionId: 'current');
      if (session.provider != 'email') return false;

      final user = await _appwriteService.account.get();
      final email = user.email;

      final userDocs = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        queries: [
          Query.equal('email', email),
        ],
      );

      if (userDocs.documents.isEmpty) return false;

      final userDoc = userDocs.documents.first;

      _userService.cacheUserInfo(user);
      NamedNavigatorImpl().push(Routes.NOTES_SCREEN, clean: true);

      final isEnabled = userDoc.data['status'] == true;

      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    _emailService.init();
    await _secureStorage.writeSecureData(CachingKey.EMAIL.value, email);
    bool otpSent = await _emailService.sendOtp(email);
    if (otpSent) {
      NamedNavigatorImpl().push(Routes.VERIFICATION_SCREEN);
    } else {
      throw Exception('Oops Something went wrong!');
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      final isVerified = await _emailService.verifyOtp(otp);

      if (!isVerified) throw Exception("Wrong or expired code");

      final user = await _appwriteService.account.get();

      final token = await _appwriteService.account.createJWT();
      await _appwriteService.storeSession(token);

      await _appwriteService.databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: user.$id,
        data: {
          "first_name": user.name.split(' ').first,
          "last_name": user.name.split(' ').last,
          "email": user.email,
          "email_verification_status": true,
          "status": true,
          "phone": user.phone,
          "created_at": DateTime.now().toIso8601String(),
          "updated_at": DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.update(Role.user(user.$id)),
          Permission.delete(Role.user(user.$id)),
        ],
      );
      _appwriteService.account
          .updateVerification(userId: user.$id, secret: token.jwt);
      _userService.cacheUserInfo(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resendOtp() async {
    final email = await _secureStorage.readSecureData(CachingKey.EMAIL.value);
    final isOtpSent = await _emailService.sendOtp(email);
    if (isOtpSent) {
      return true;
    } else {
      return false;
    }
  }
}
