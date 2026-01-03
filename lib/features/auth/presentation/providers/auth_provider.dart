import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Provider for authentication state management
class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Initialize auth state (check if user is logged in)
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        _user = await authRepository.getMe();
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await authRepository.login(
        email: email,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      await authRepository.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh user data
  Future<void> refreshUser() async {
    if (_status != AuthStatus.authenticated) return;
    
    try {
      _user = await authRepository.getMe();
      notifyListeners();
    } catch (e) {
      // Handle error silently or logout
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
