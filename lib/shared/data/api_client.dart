import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import 'token_storage.dart';

/// Dio-based API client with interceptors for auth and logging
class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;
  
  // Callback to notify when token is invalid (401)
  Function()? onUnauthorized;
  
  ApiClient({
    TokenStorage? tokenStorage,
    this.onUnauthorized,
  }) : _tokenStorage = tokenStorage ?? TokenStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectionTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization header if token exists
          final token = await _tokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          // Log request in debug mode
          if (kDebugMode) {
            print('🌐 [${options.method}] ${options.uri}');
            if (options.data != null) {
              print('📤 Request Data: ${options.data}');
            }
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in debug mode
          if (kDebugMode) {
            print('✅ [${response.statusCode}] ${response.requestOptions.uri}');
            print('📥 Response Data: ${response.data}');
          }
          
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Log error in debug mode
          if (kDebugMode) {
            print('❌ [${error.response?.statusCode}] ${error.requestOptions.uri}');
            print('⚠️  Error: ${error.message}');
            if (error.response?.data != null) {
              print('📥 Error Data: ${error.response?.data}');
            }
          }
          
          // Handle 401 Unauthorized
          if (error.response?.statusCode == 401) {
            await _tokenStorage.clearAllTokens();
            onUnauthorized?.call();
          }
          
          return handler.next(error);
        },
      ),
    );
  }
  
  // ==================== HTTP Methods ====================
  
  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Multipart POST request (for file uploads)
  Future<Response<T>> postMultipart<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Multipart PUT request (for file uploads)
  Future<Response<T>> putMultipart<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== Error Handling ====================
  
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        // Handle FastAPI validation errors
        if (statusCode == 422 || statusCode == 400) {
          if (responseData is Map && responseData['detail'] is List) {
            // Parse FastAPI validation error format
            final List<dynamic> errors = responseData['detail'];
            final errorMessages = errors.map((e) {
              if (e is Map) {
                final loc = e['loc'] as List?;
                final msg = e['msg'] as String?;
                final field = loc?.last?.toString() ?? 'field';
                return '$field: ${msg ?? 'Invalid value'}';
              }
              return e.toString();
            }).join(', ');
            return Exception('Validation error: $errorMessages');
          }
        }
        
        // Safely extract error message - handle both Map and non-Map responses
        String message = 'Something went wrong';
        if (responseData is Map<String, dynamic>) {
          message = responseData['message']?.toString() ?? 
                   responseData['error']?.toString() ?? 
                   responseData['detail']?.toString() ??
                   'Something went wrong';
        } else if (responseData != null) {
          // Response data is String, int, or other non-Map type
          message = responseData.toString();
        }
        
        if (statusCode == 400) {
          return Exception('Bad request: $message');
        } else if (statusCode == 401) {
          return Exception('Unauthorized. Please login again.');
        } else if (statusCode == 403) {
          return Exception('Access forbidden: $message');
        } else if (statusCode == 404) {
          return Exception('Resource not found');
        } else if (statusCode == 500) {
          return Exception('Server error. Please try again later.');
        }
        return Exception(message);
      
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      
      case DioExceptionType.connectionError:
        return Exception('No internet connection');
      
      case DioExceptionType.badCertificate:
        return Exception('Security certificate error');
      
      case DioExceptionType.unknown:
        return Exception('Unexpected error: ${error.message}');
    }
  }
  
  /// Get raw Dio instance (for advanced use cases)
  Dio get dio => _dio;
}
