import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';

// Core Services
import 'shared/data/api_client.dart';
import 'shared/data/token_storage.dart';
import 'shared/data/cache_manager.dart';

// Data Sources
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/wardrobe/data/datasources/wardrobe_remote_datasource.dart';

// Repositories
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/wardrobe/data/repositories/wardrobe_repository_impl.dart';
import 'features/wardrobe/data/repositories/mix_match_repository_impl.dart';

// Providers
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/wardrobe/presentation/providers/outfit_list_provider.dart';
import 'features/wardrobe/presentation/providers/outfit_detail_provider.dart';
import 'features/wardrobe/presentation/providers/outfit_form_provider.dart';
import 'features/wardrobe/presentation/providers/favorites_provider.dart';
import 'features/wardrobe/presentation/providers/categories_provider.dart';
import 'features/mix_match/presentation/providers/mix_match_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services
  final tokenStorage = TokenStorage();
  final cacheManager = await CacheManager.init();
  final apiClient = ApiClient(
    tokenStorage: tokenStorage,
    onUnauthorized: () {
      // Handle unauthorized - will be used by providers to logout
    },
  );
  
  // Initialize data sources
  final authDataSource = AuthRemoteDataSource(
    apiClient: apiClient,
    tokenStorage: tokenStorage,
  );
  final wardrobeDataSource = WardrobeRemoteDataSource(
    apiClient: apiClient,
  );
  
  // Initialize repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authDataSource,
    tokenStorage: tokenStorage,
  );
  final wardrobeRepository = WardrobeRepositoryImpl(
    remoteDataSource: wardrobeDataSource,
    cacheManager: cacheManager,
  );
  final mixMatchRepository = MixMatchRepositoryImpl(
    remoteDataSource: wardrobeDataSource,
    cacheManager: cacheManager,
  );
  
  runApp(MyApp(
    authRepository: authRepository,
    wardrobeRepository: wardrobeRepository,
    mixMatchRepository: mixMatchRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final WardrobeRepositoryImpl wardrobeRepository;
  final MixMatchRepositoryImpl mixMatchRepository;
  
  const MyApp({
    super.key,
    required this.authRepository,
    required this.wardrobeRepository,
    required this.mixMatchRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository: authRepository)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => OutfitListProvider(repository: wardrobeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OutfitDetailProvider(repository: wardrobeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OutfitFormProvider(repository: wardrobeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(repository: wardrobeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoriesProvider(repository: wardrobeRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => MixMatchProvider(
            repository: mixMatchRepository,
            wardrobeRepository: wardrobeRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Digital Wardrobe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
