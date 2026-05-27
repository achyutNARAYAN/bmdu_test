import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _initialized = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _initialized;
  String? get errorMessage => _errorMessage;

  Future<void> loadSession() async {
    _isLoggedIn = await _storage.getLoginSession();
    _initialized = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _errorMessage = null;
    if (!_validateEmail(email)) {
      _errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }
    if (!_validatePassword(password)) {
      _errorMessage = 'Password must be at least 8 characters.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 900));

    _isLoading = false;
    _isLoggedIn = true;
    await _storage.saveLoginSession(true);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    await _storage.saveLoginSession(false);
    notifyListeners();
  }

  bool _validateEmail(String value) {
    return value.contains('@') && value.contains('.') && value.trim().length >= 6;
  }

  bool _validatePassword(String value) {
    return value.trim().length >= 8;
  }
}
