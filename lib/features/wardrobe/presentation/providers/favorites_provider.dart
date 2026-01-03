import 'package:flutter/foundation.dart';
import '../../domain/entities/outfit_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';

/// Provider for favorites list
class FavoritesProvider with ChangeNotifier {
  final WardrobeRepository repository;

  FavoritesProvider({required this.repository});

  List<OutfitItem> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OutfitItem> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get favoritesCount => _favorites.length;

  /// Load all favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await repository.listFavorites();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite (add/remove)
  Future<void> toggleFavorite(String outfitId) async {
    try {
      final isFavorite = await repository.toggleFavorite(outfitId);
      
      if (isFavorite) {
        // Outfit was added to favorites - reload list to get updated data
        await loadFavorites();
      } else {
        // Outfit was removed from favorites
        _favorites.removeWhere((f) => f.id == outfitId);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Check if outfit is favorited
  bool isFavorite(String outfitId) {
    return _favorites.any((f) => f.id == outfitId);
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
