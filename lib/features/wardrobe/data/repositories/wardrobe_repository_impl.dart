import '../../domain/entities/outfit_item.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/wardrobe_repository.dart';
import '../datasources/wardrobe_remote_datasource.dart';
import '../../../../shared/data/cache_manager.dart';
import '../models/outfit_model.dart';
import '../../../../core/constants/outfit_categories.dart';

/// Implementation of WardrobeRepository
class WardrobeRepositoryImpl implements WardrobeRepository {
  final WardrobeRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;

  WardrobeRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
  });

  @override
  Future<List<OutfitItem>> listOutfits({
    String? category,
    String? searchQuery,
    bool? favoritesOnly,
  }) async {
    try {
      final outfitModels = await remoteDataSource.listOutfits(
        category: category,
        searchQuery: searchQuery,
        favoritesOnly: favoritesOnly,
      );

      // Cache the results
      await cacheManager.cacheOutfits(
        outfitModels.map((m) => m.toJson()).toList(),
      );

      return outfitModels.map((m) => m.toEntity()).toList();
    } catch (e) {
      // Try to return cached data on error
      final cachedData = cacheManager.getCachedOutfits();
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData
            .map((json) => OutfitModel.fromJson(json).toEntity())
            .toList();
      }
      rethrow;
    }
  }

  @override
  Future<OutfitItem> getOutfit(String outfitId) async {
    try {
      final outfitModel = await remoteDataSource.getOutfit(outfitId);
      return outfitModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OutfitItem> createOutfit({
    required String name,
    required String category,
    required String color,
    String? notes,
    String? imagePath,
  }) async {
    try {
      final outfitModel = await remoteDataSource.createOutfit(
        name: name,
        category: category,
        color: color,
        notes: notes,
        imagePath: imagePath,
      );

      // Invalidate cache
      await cacheManager.clearOutfitsCache();

      return outfitModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OutfitItem> updateOutfit({
    required String outfitId,
    String? name,
    String? category,
    String? color,
    String? notes,
    String? imagePath,
  }) async {
    try {
      final outfitModel = await remoteDataSource.updateOutfit(
        outfitId: outfitId,
        name: name,
        category: category,
        color: color,
        notes: notes,
        imagePath: imagePath,
      );

      // Invalidate cache
      await cacheManager.clearOutfitsCache();

      return outfitModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteOutfit(String outfitId) async {
    try {
      await remoteDataSource.deleteOutfit(outfitId);

      // Invalidate cache
      await cacheManager.clearOutfitsCache();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> toggleFavorite(String outfitId) async {
    try {
      final isFavorite = await remoteDataSource.toggleFavorite(outfitId);

      // Update cache
      await cacheManager.toggleFavoriteInCache(outfitId);

      return isFavorite;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> listFavoriteIds() async {
    try {
      return await remoteDataSource.listFavoriteIds();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OutfitItem>> listFavorites() async {
    try {
      // Get favorite IDs first
      final favoriteIds = await remoteDataSource.listFavoriteIds();
      
      if (favoriteIds.isEmpty) {
        return [];
      }
      
      // Fetch all outfits and filter by favorite IDs
      final allOutfits = await remoteDataSource.listOutfits();
      final favoriteOutfits = allOutfits
          .where((outfit) => favoriteIds.contains(outfit.id))
          .map((model) => model.toEntity())
          .toList();
      
      return favoriteOutfits;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> listCategories() async {
    // Return static categories from enum (can be extended to fetch from API)
    return OutfitCategory.values.map((category) {
      return Category(
        id: category.value,
        name: category.displayName,
        value: category.value,
      );
    }).toList();
  }
}
