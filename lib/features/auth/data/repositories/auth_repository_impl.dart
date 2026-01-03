import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../shared/data/token_storage.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await tokenStorage.clearAllTokens();
    } catch (e) {
      // Clear tokens even if API call fails
      await tokenStorage.clearAllTokens();
      rethrow;
    }
  }

  @override
  Future<User> getMe() async {
    try {
      final userModel = await remoteDataSource.getMe();
      return userModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await tokenStorage.isAuthenticated();
  }
}
