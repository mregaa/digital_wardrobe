import 'package:dio/dio.dart';
import '../models/outfit_model.dart';
import '../../../../shared/data/api_client.dart';
import '../../../../core/constants/app_constants.dart';

/// Remote data source for wardrobe/outfit operations
class WardrobeRemoteDataSource {
  final ApiClient apiClient;

  WardrobeRemoteDataSource({
    required this.apiClient,
  });

  /// Get all outfits with optional filters
  Future<List<OutfitModel>> listOutfits({
    String? category,
    String? searchQuery,
    bool? favoritesOnly,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (category != null) queryParams['category'] = category;
      if (searchQuery != null) queryParams['search'] = searchQuery;
      if (favoritesOnly != null) queryParams['favorites'] = favoritesOnly;

      print('📤 [LIST OUTFITS] Query params: $queryParams');

      final response = await apiClient.get(
        '${AppConstants.outfitsEndpoint}/',  // Trailing slash required for GET collection
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [LIST OUTFITS] Response type: ${response.data.runtimeType}');
      print('   First item sample: ${response.data is List && (response.data as List).isNotEmpty ? (response.data as List).first : "empty or not list"}');

      // Backend returns array directly, NOT wrapped in {"outfits": [...]}
      final List<dynamic> outfitsData;
      if (response.data is List) {
        outfitsData = response.data as List;
      } else if (response.data is Map) {
        // Fallback for wrapped response
        outfitsData = response.data['outfits'] ?? response.data['data'] ?? [];
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }
      
      print('   Parsing ${outfitsData.length} outfits...');
      return outfitsData.map((json) => OutfitModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      print('❌ [LIST OUTFITS] Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Get single outfit by ID
  Future<OutfitModel> getOutfit(String outfitId) async {
    try {
      print('📤 [GET OUTFIT] ID: $outfitId');
      
      final response = await apiClient.get('${AppConstants.outfitsEndpoint}/$outfitId');

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [GET OUTFIT] Response: ${response.data}');

      // Backend returns outfit data directly
      return OutfitModel.fromJson(response.data);
    } catch (e, stackTrace) {
      print('❌ [GET OUTFIT] Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Create new outfit
  Future<OutfitModel> createOutfit({
    required String name,
    required String category,
    required String color,
    String? notes,
    String? imagePath,
  }) async {
    try {
      print('📤 [CREATE OUTFIT] Request:');
      print('  name: $name');
      print('  category: $category');
      print('  color: $color');
      print('  notes: $notes');
      print('  imagePath: $imagePath');

      // Backend expects multipart/form-data ALWAYS (even without image)
      final formData = FormData.fromMap({
        'name': name,
        'category': category,
        'color': color,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      // Add image if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
        print('  📷 Image attached: ${imagePath.split('/').last}');
      }

      final response = await apiClient.postMultipart(
        '${AppConstants.outfitsEndpoint}/',  // Trailing slash required for POST
        formData: formData,
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [CREATE OUTFIT] Response: ${response.data}');

      // Backend returns outfit data directly (not wrapped)
      return OutfitModel.fromJson(response.data);
    } catch (e, stackTrace) {
      print('❌ [CREATE OUTFIT] Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Update existing outfit
  Future<OutfitModel> updateOutfit({
    required String outfitId,
    String? name,
    String? category,
    String? color,
    String? notes,
    String? imagePath,
  }) async {
    try {
      print('📤 [UPDATE OUTFIT] ID: $outfitId');
      print('  name: $name, category: $category, color: $color');

      // Backend expects multipart/form-data for PUT as well
      final formData = FormData.fromMap({
        if (name != null && name.isNotEmpty) 'name': name,
        if (category != null && category.isNotEmpty) 'category': category,
        if (color != null && color.isNotEmpty) 'color': color,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });

      // Add image if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'image',
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
        print('  📷 Image attached: ${imagePath.split('/').last}');
      }

      final response = await apiClient.putMultipart(
        '${AppConstants.outfitsEndpoint}/$outfitId',
        formData: formData,
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [UPDATE OUTFIT] Response: ${response.data}');

      // Backend returns outfit data directly
      return OutfitModel.fromJson(response.data);
    } catch (e, stackTrace) {
      print('❌ [UPDATE OUTFIT] Error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Delete outfit
  Future<void> deleteOutfit(String outfitId) async {
    try {
      print('🗑️ [DELETE OUTFIT] ID: $outfitId');
      await apiClient.delete('${AppConstants.outfitsEndpoint}/$outfitId');
      print('✅ [DELETE OUTFIT] Success');
    } catch (e) {
      print('❌ [DELETE OUTFIT] Error: $e');
      rethrow;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String outfitId) async {
    try {
      print('⭐ [TOGGLE FAVORITE] Outfit ID: $outfitId');
      
      // Backend expects: POST /favorites/toggle with JSON body
      final response = await apiClient.post(
        '${AppConstants.favoritesEndpoint}/toggle',
        data: {'outfit_id': outfitId},
      );

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [TOGGLE FAVORITE] Response: ${response.data}');

      // Backend returns: { "isFavorite": true, "message": "..." }
      return response.data['isFavorite'] as bool? ?? false;
    } catch (e) {
      print('❌ [TOGGLE FAVORITE] Error: $e');
      rethrow;
    }
  }

  /// Get all favorite outfit IDs
  Future<List<String>> listFavoriteIds() async {
    try {
      print('📤 [LIST FAVORITES]');
      
      final response = await apiClient.get(AppConstants.favoritesEndpoint);

      if (response.data == null) {
        throw Exception('No data received from server');
      }

      print('✅ [LIST FAVORITES] Response: ${response.data}');

      // Backend returns: { "favorites": ["id1", "id2", ...] }
      final List<dynamic> favoritesData = response.data['favorites'] ?? [];
      
      return favoritesData.map((id) => id.toString()).toList();
    } catch (e) {
      print('❌ [LIST FAVORITES] Error: $e');
      rethrow;
    }
  }
}
