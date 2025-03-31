import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/data/security.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator.dart';
import 'package:escooter_notes_app/managers/navigator/named_navigator_implementation.dart';
import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:escooter_notes_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthenticationRepository _authRepository;
  final UserRepository _userRepository;

  AuthenticationProvider(this._authRepository, this._userRepository);

  bool? _isLoading = false;
  bool? _isAuthenticated = false;
  String? _errorMessage;
  String? _successMessage;
  Document? _currentUser;

  bool? get isLoading => _isLoading;

  bool? get isAuthenticated => _isAuthenticated;

  String? get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  Document? get currentUser => _currentUser;

  set errorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  set successMessage(String? message) {
    _successMessage = message;
    notifyListeners();
  }

  set isLoading(bool? isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  set isAuthenticated(bool? isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  set currentUser(Document? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> initialize() async {
    isLoading = true;

    try {
      isAuthenticated = await _authRepository.isLoggedIn();
      if (isAuthenticated ?? false) {
        await _loadCurrentUser();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      final userData = await _userRepository.getUserData(user.$id);
      currentUser = userData;
    } catch (e) {
      errorMessage = 'Failed to load user data';
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      await _authRepository.login(email, password);
      isAuthenticated = true;
      await _loadCurrentUser();
      NamedNavigatorImpl().push(Routes.NOTES_SCREEN);
    } catch (e) {
      errorMessage = e.toString();
      isAuthenticated = false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> createAccount(
      String email, String password, String name, String phone) async {
    isLoading = true;
    errorMessage = null;

    try {
      await _authRepository.createAccount(email, password, name, phone);

      await _authRepository.sendVerificationEmail(email);

      NamedNavigatorImpl().push(Routes.VERIFICATION_SCREEN);

      currentUser = null;
      isAuthenticated = false;
    } catch (e) {
      errorMessage = e.toString();
      isAuthenticated = false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> checkIfUserIsVerified() async {
    try {
      final user = await _authRepository.getCurrentUser();
      return user.emailVerification;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _isAuthenticated = false;
      _currentUser = null;
      await SecureStorage().deleteAll();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      await _authRepository.verifyOtp(otp);
    } catch (e) {
      errorMessage = "Invalid Code..Please try again";
    }
  }

  Future<void> resendOtp() async {
    isLoading = true;
    final isOtpResent = await _authRepository.resendOtp();
    if (isOtpResent) {
      successMessage = "Otp is resent successfully";
      isLoading = false;
    } else {
      errorMessage = "Failed to resend otp";
      isLoading = false;
    }
  }
}
