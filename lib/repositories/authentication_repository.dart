import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/data/security.dart';
import 'package:escooter_notes_app/managers/caching/cashing_key.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/services/email_service.dart';

import '../services/app_write_service.dart';
import '../utils/config/config.dart';

class AuthenticationRepository {
  final AppwriteService _appwriteService;
  final EmailService _emailService;

  AuthenticationRepository(this._appwriteService, this._emailService);

  Future<void> login(String email, String password) async {
    try {
      final session =
          await _appwriteService.account.getSession(sessionId: 'current');

      if (session.provider == 'email') {
        // Session already exists, optionally re-fetch user
        final user = await _appwriteService.account.get();
        final token = await _appwriteService.account.createJWT();
        await _appwriteService.storeSession(token);
        return;
      }
    } catch (_) {
      throw Exception("No Valid Session");
    }

    try {
      // 2. Create a new session
      await _appwriteService.account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // 3. Fetch user info
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
      // 1. Get current session
      final session =
          await _appwriteService.account.getSession(sessionId: 'current');
      if (session.provider != 'email') return false;

      // 2. Get the current user to extract their email
      final user = await _appwriteService.account.get();
      final email = user.email;

      // 3. Query the users collection to find user by email
      final userDocs = await _appwriteService.databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        queries: [
          Query.equal('email', email),
        ],
      );

      // 4. If no document found, return false
      if (userDocs.documents.isEmpty) return false;

      final userDoc = userDocs.documents.first;

      // 5. Check the 'status' field (or 'enabled' field if named that)
      final isEnabled = userDoc.data['status'] == true;

      return isEnabled;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendVerificationEmail(String email) async {
    _emailService.init();
    await SecureStorage().writeSecureData(CachingKey.EMAIL.value, email);
    bool otpSent = await _emailService.sendOtp(email);
    if (otpSent) {
      NamedNavigatorImpl().push(Routes.VERIFICATION_SCREEN);
    } else {
      throw Exception('Oops Something went wrong!');
    }
  }

  Future<void> verifyOtp(String otp) async {
    final isVerified = await _emailService.verifyOtp(otp);

    if (!isVerified) throw Exception("Wrong or expired code");

    // Get current user
    final user = await _appwriteService.account.get();
    // Create JWT (store session)
    final token = await _appwriteService.account.createJWT();
    await _appwriteService.storeSession(token);

    // Create user document in the 'users' collection
    await _appwriteService.databases.createDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollectionId,
      documentId: user.$id,
      // use same ID for consistency
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
    // Navigate to home

    await SecureStorage().writeSecureData(
        CachingKey.FIRST_NAME.value, user.name.split(' ').first);
    await SecureStorage()
        .writeSecureData(CachingKey.LAST_NAME.value, user.name.split(' ').last);
    await SecureStorage().writeSecureData(CachingKey.EMAIL.value, user.email);
    await SecureStorage()
        .writeSecureData(CachingKey.PHONE_NUMBER.value, user.phone);
    await SecureStorage().writeSecureData(CachingKey.USER_ID.value, user.$id);
    NamedNavigatorImpl().push(Routes.NOTES_SCREEN, clean: true);
  }

  Future<bool> resendOtp() async {
    final email = await SecureStorage().readSecureData(CachingKey.EMAIL.value);
    final isOtpSent = await _emailService.sendOtp(email);
    if (isOtpSent) {
      return true;
    } else {
      return false;
    }
  }
}
