import '../entities/outfit_item.dart';
import '../entities/category.dart';

/// Wardrobe repository interface
abstract class WardrobeRepository {
  /// Get all outfits
  Future<List<OutfitItem>> listOutfits({
    String? category,
    String? searchQuery,
    bool? favoritesOnly,
  });

  /// Get single outfit by ID
  Future<OutfitItem> getOutfit(String outfitId);

  /// Create a new outfit
  Future<OutfitItem> createOutfit({
    required String name,
    required String category,
    required String color,
    String? notes,
    String? imagePath,
  });

  /// Update existing outfit
  Future<OutfitItem> updateOutfit({
    required String outfitId,
    String? name,
    String? category,
    String? color,
    String? notes,
    String? imagePath,
  });

  /// Delete outfit
  Future<void> deleteOutfit(String outfitId);

  /// Toggle favorite status (returns new favorite state)
  Future<bool> toggleFavorite(String outfitId);

  /// Get all favorite outfit IDs
  Future<List<String>> listFavoriteIds();

  /// Get all favorites (fetches full outfit data)
  Future<List<OutfitItem>> listFavorites();

  /// Get all categories
  Future<List<Category>> listCategories();
}
