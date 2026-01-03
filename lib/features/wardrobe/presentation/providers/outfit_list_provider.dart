import 'package:flutter/foundation.dart';
import '../../domain/entities/outfit_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';

/// Provider for outfit list with filters
class OutfitListProvider with ChangeNotifier {
  final WardrobeRepository repository;

  OutfitListProvider({required this.repository});

  List<OutfitItem> _outfits = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filters
  String? _selectedCategory;
  String? _searchQuery;
  bool _showFavoritesOnly = false;

  List<OutfitItem> get outfits => _outfits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  String? get searchQuery => _searchQuery;
  bool get showFavoritesOnly => _showFavoritesOnly;

  /// Load outfits with current filters
  Future<void> loadOutfits() async {
    print('🔄 [OUTFIT_LIST_PROVIDER] Starting loadOutfits...');
    print('   Filters: category=$_selectedCategory, search=$_searchQuery, favoritesOnly=$_showFavoritesOnly');
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _outfits = await repository.listOutfits(
        category: _selectedCategory,
        searchQuery: _searchQuery,
        favoritesOnly: _showFavoritesOnly,
      );
      print('✅ [OUTFIT_LIST_PROVIDER] Loaded ${_outfits.length} outfits');
      if (_outfits.isNotEmpty) {
        print('   First outfit: ${_outfits.first.name}');
      }
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      print('❌ [OUTFIT_LIST_PROVIDER] Error: $e');
      print('   Stack trace: $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set category filter
  Future<void> setCategory(String? category) async {
    _selectedCategory = category;
    await loadOutfits();
  }

  /// Set search query
  Future<void> setSearchQuery(String? query) async {
    _searchQuery = query;
    await loadOutfits();
  }

  /// Toggle favorites filter
  Future<void> toggleFavoritesFilter() async {
    _showFavoritesOnly = !_showFavoritesOnly;
    await loadOutfits();
  }

  /// Toggle favorite status of an outfit
  Future<void> toggleFavorite(String outfitId) async {
    try {
      final isFavorite = await repository.toggleFavorite(outfitId);
      
      // Update local list
      final index = _outfits.indexWhere((o) => o.id == outfitId);
      if (index != -1) {
        _outfits[index] = _outfits[index].copyWith(isFavorite: isFavorite);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete outfit
  Future<bool> deleteOutfit(String outfitId) async {
    try {
      await repository.deleteOutfit(outfitId);
      _outfits.removeWhere((o) => o.id == outfitId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _selectedCategory = null;
    _searchQuery = null;
    _showFavoritesOnly = false;
    await loadOutfits();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
