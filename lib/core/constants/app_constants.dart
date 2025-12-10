class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String imageBaseUrl = 'http://localhost:8000';
  
  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String outfitsEndpoint = '/outfits';
  static const String categoriesEndpoint = '/categories';
  static const String favoritesEndpoint = '/favorites';
  static const String recommendationsEndpoint = '/recommendations';
  
  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cacheKey = 'outfit_cache';
  
  // App Settings
  static const int cacheValidityHours = 24;
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
