import '../entities/user.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Register a new user
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Login user
  Future<User> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current user info
  Future<User> getMe();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}
