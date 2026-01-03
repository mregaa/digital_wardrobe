import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import '../../../../shared/data/api_client.dart';
import '../../../../shared/data/token_storage.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';

/// Remote data source for authentication
class AuthRemoteDataSource {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  AuthRemoteDataSource({
    required this.apiClient,
    required this.tokenStorage,
  });

  /// Register new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 [AUTH] Registering user: $email');
      
      final response = await apiClient.post(
        AppConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      debugPrint('✅ [AUTH] Register response: ${response.data}');

      // Parse auth response (backend returns: { "access_token": "...", "token_type": "bearer" })
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      // Save token
      await tokenStorage.saveAccessToken(authResponse.accessToken);
      debugPrint('💾 [AUTH] Token saved: ${authResponse.accessToken.substring(0, 20)}...');

      // Fetch user data using the token
      final user = await getMe();
      debugPrint('👤 [AUTH] User fetched: ${user.email}');
      
      return user;
    } catch (e, stackTrace) {
      debugPrint('❌ [AUTH] Register error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Login user
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint('🔐 [AUTH] Logging in user: $email');
      
      final response = await apiClient.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      debugPrint('✅ [AUTH] Login response: ${response.data}');

      // Parse auth response (backend returns: { "access_token": "...", "token_type": "bearer" })
      final authResponse = AuthResponseModel.fromJson(response.data);
      
      // Save token
      await tokenStorage.saveAccessToken(authResponse.accessToken);
      debugPrint('💾 [AUTH] Token saved: ${authResponse.accessToken.substring(0, 20)}...');

      // Fetch user data using the token
      final user = await getMe();
      debugPrint('👤 [AUTH] User fetched: ${user.email}');
      
      return user;
    } catch (e, stackTrace) {
      debugPrint('❌ [AUTH] Login error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await apiClient.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Continue even if API call fails
    }
  }

  /// Get current user
  Future<UserModel> getMe() async {
    try {
      debugPrint('👤 [AUTH] Fetching current user...');
      
      final response = await apiClient.get('/auth/me');

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      debugPrint('✅ [AUTH] GetMe response: ${response.data}');

      // Backend returns user data directly: { "id": "...", "name": "...", "email": "..." }
      final userData = response.data;
      
      if (userData['id'] == null) {
        throw Exception('User ID is missing from response');
      }
      if (userData['email'] == null) {
        throw Exception('User email is missing from response');
      }
      if (userData['name'] == null) {
        throw Exception('User name is missing from response');
      }
      
      return UserModel.fromJson(userData);
    } catch (e, stackTrace) {
      debugPrint('❌ [AUTH] GetMe error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
