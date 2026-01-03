import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../../../wardrobe/domain/entities/outfit_item.dart';
import '../../../wardrobe/domain/repositories/mix_match_repository.dart';
import '../../../wardrobe/domain/repositories/wardrobe_repository.dart';

/// Represents an outfit item placed on the canvas
class PlacedOutfitItem {
  final String id; // unique id for this placement
  final String outfitId; // reference to original outfit
  final String? imageUrl;
  final String name;
  final String category;
  Offset position;
  double scale; // scale factor (default 1.0)
  double rotation; // rotation in radians (default 0.0)

  PlacedOutfitItem({
    required this.id,
    required this.outfitId,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });
}

/// Provider for Avatar Outfit Builder (Mix & Match)
class MixMatchProvider with ChangeNotifier {
  final MixMatchRepository mixMatchRepository;
  final WardrobeRepository wardrobeRepository;

  MixMatchProvider({
    required MixMatchRepository repository,
    required this.wardrobeRepository,
  }) : mixMatchRepository = repository;

  // All available outfits from wardrobe
  List<OutfitItem> _allOutfits = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Placed items on canvas (for new Marvelous Designer-style UI)
  final List<PlacedOutfitItem> _placedItems = [];
  int _placementIdCounter = 0;

  // Library view
  String? _selectedLibraryCategory; // null = "All"
  
  // Saved combos
  final List<SavedCombo> _savedCombos = [];

  // Getters
  List<OutfitItem> get allOutfits => _allOutfits;
  List<PlacedOutfitItem> get placedItems => List.unmodifiable(_placedItems);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedLibraryCategory => _selectedLibraryCategory;
  List<SavedCombo> get savedCombos => List.unmodifiable(_savedCombos);

  // Get filtered library items based on selected category
  List<OutfitItem> get libraryItems {
    if (_selectedLibraryCategory == null) {
      return _allOutfits;
    }
    return _allOutfits
        .where((item) => item.category.toLowerCase() == _selectedLibraryCategory!.toLowerCase())
        .toList();
  }

  // Check if any items are placed on canvas
  bool get hasPlacedItems => _placedItems.isNotEmpty;

  /// Load all outfits
  Future<void> loadOutfits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allOutfits = await wardrobeRepository.listOutfits();
      print('✅ [MIX_MATCH] Loaded ${_allOutfits.length} outfits');
    } catch (e) {
      _errorMessage = e.toString();
      print('❌ [MIX_MATCH] Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set library category filter
  void setLibraryCategory(String? category) {
    _selectedLibraryCategory = category;
    notifyListeners();
  }

  /// Add a placed item to canvas
  void addPlacedItem(String outfitId, String? imageUrl, String name, String category, Offset position) {
    final placementId = 'placed_${_placementIdCounter++}_$outfitId';
    final placedItem = PlacedOutfitItem(
      id: placementId,
      outfitId: outfitId,
      imageUrl: imageUrl,
      name: name,
      category: category,
      position: position,
    );
    _placedItems.add(placedItem);
    notifyListeners();
    print('✅ [MIX_MATCH] Added $name to canvas at $position');
  }

  /// Update position of a placed item on canvas
  void updatePlacedItemPosition(String placementId, Offset newPosition) {
    final index = _placedItems.indexWhere((item) => item.id == placementId);
    if (index != -1) {
      _placedItems[index].position = newPosition;
      notifyListeners();
    }
  }

  /// Update transform (position, scale, rotation) of a placed item
  void updatePlacedItemTransform(String placementId, Offset newPosition, double newScale, double newRotation) {
    final index = _placedItems.indexWhere((item) => item.id == placementId);
    if (index != -1) {
      _placedItems[index].position = newPosition;
      // Clamp scale to safe range (0.2 to 4.0)
      _placedItems[index].scale = newScale.clamp(0.2, 4.0);
      _placedItems[index].rotation = newRotation;
      notifyListeners();
    }
  }

  /// Bring placed item to front (z-order)
  void bringToFront(String placementId) {
    final index = _placedItems.indexWhere((item) => item.id == placementId);
    if (index != -1 && index != _placedItems.length - 1) {
      final item = _placedItems.removeAt(index);
      _placedItems.add(item);
      notifyListeners();
    }
  }

  /// Remove a placed item from canvas
  void removePlacedItem(String placementId) {
    _placedItems.removeWhere((item) => item.id == placementId);
    notifyListeners();
    print('🗑️ [MIX_MATCH] Removed item from canvas');
  }

  /// Clear all placed items from canvas
  void clearCanvas() {
    _placedItems.clear();
    notifyListeners();
    print('🗑️ [MIX_MATCH] Cleared canvas');
  }

  /// Save current canvas state
  void saveCombo(String name) {
    if (!hasPlacedItems) {
      print('⚠️ [MIX_MATCH] Cannot save empty canvas');
      return;
    }

    // Note: SavedCombo needs to be updated to work with PlacedOutfitItems
    // For now, keeping basic structure
    notifyListeners();
    print('💾 [MIX_MATCH] Saved combo: $name');
  }
}

/// Model for saved combinations (simplified for now)
class SavedCombo {
  final String id;
  final String name;
  final DateTime savedAt;

  SavedCombo({
    required this.id,
    required this.name,
    required this.savedAt,
  });
}
