import 'package:appwrite/models.dart';
import 'package:escooter_notes_app/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:escooter_notes_app/repositories/user_repository.dart';

class AuthenticationProvider with ChangeNotifier {
  final AuthenticationRepository _authRepository;
  final UserRepository _userRepository;

  AuthenticationProvider(this._authRepository, this._userRepository);

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  Document? _currentUser;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  Document? get currentUser => _currentUser;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAuthenticated = await _authRepository.isLoggedIn();
      if (_isAuthenticated) {
        await _loadCurrentUser();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userData = await _userRepository.getUserData('current-user-id');
      _currentUser = userData;
    } catch (e) {
      _errorMessage = 'Failed to load user data';
      await logout();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.login(email, password);
      _isAuthenticated = true;
      await _loadCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAccount(String email, String password, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.createAccount(email, password, name);
      _isAuthenticated = true;
      await _loadCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _isAuthenticated = false;
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}