import 'package:flutter/foundation.dart';
import '../../domain/entities/outfit_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';

/// Provider for single outfit details
class OutfitDetailProvider with ChangeNotifier {
  final WardrobeRepository repository;

  OutfitDetailProvider({required this.repository});

  OutfitItem? _outfit;
  bool _isLoading = false;
  String? _errorMessage;

  OutfitItem? get outfit => _outfit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load outfit by ID
  Future<void> loadOutfit(String outfitId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _outfit = await repository.getOutfit(outfitId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite
  Future<void> toggleFavorite() async {
    if (_outfit == null) return;

    try {
      final isFavorite = await repository.toggleFavorite(_outfit!.id);
      
      // Update local outfit with new favorite status
      _outfit = _outfit!.copyWith(isFavorite: isFavorite);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete outfit
  Future<bool> deleteOutfit() async {
    if (_outfit == null) return false;

    try {
      await repository.deleteOutfit(_outfit!.id);
      _outfit = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Clear current outfit
  void clear() {
    _outfit = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
