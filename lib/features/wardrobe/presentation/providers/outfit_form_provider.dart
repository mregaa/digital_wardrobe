import 'package:flutter/foundation.dart';
import '../../domain/entities/outfit_item.dart';
import '../../domain/repositories/wardrobe_repository.dart';

/// Provider for outfit form (add/edit)
class OutfitFormProvider with ChangeNotifier {
  final WardrobeRepository repository;

  OutfitFormProvider({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  
  // Form fields
  String? _name;
  String? _category;
  String? _color;
  String? _notes;
  String? _imagePath;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get name => _name;
  String? get category => _category;
  String? get color => _color;
  String? get notes => _notes;
  String? get imagePath => _imagePath;

  /// Initialize form with existing outfit (for editing)
  void initializeWithOutfit(OutfitItem outfit) {
    _name = outfit.name;
    _category = outfit.category;
    _color = outfit.color;
    _notes = outfit.notes;
    _imagePath = null; // Don't set existing URL, user must pick new image
    notifyListeners();
  }

  /// Update name
  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  /// Update category
  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  /// Update color
  void setColor(String value) {
    _color = value;
    notifyListeners();
  }

  /// Update notes
  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  /// Update image path
  void setImagePath(String? path) {
    _imagePath = path;
    notifyListeners();
  }

  /// Validate form
  bool validate() {
    if (_name == null || _name!.trim().isEmpty) {
      _errorMessage = 'Name is required';
      notifyListeners();
      return false;
    }

    if (_category == null || _category!.trim().isEmpty) {
      _errorMessage = 'Category is required';
      notifyListeners();
      return false;
    }

    if (_color == null || _color!.trim().isEmpty) {
      _errorMessage = 'Color is required';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// Create new outfit
  Future<OutfitItem?> createOutfit() async {
    if (!validate()) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final outfit = await repository.createOutfit(
        name: _name!,
        category: _category!,
        color: _color!,
        notes: _notes,
        imagePath: _imagePath,
      );
      
      reset(); // Clear form after successful creation
      return outfit;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update existing outfit
  Future<OutfitItem?> updateOutfit(String outfitId) async {
    if (!validate()) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final outfit = await repository.updateOutfit(
        outfitId: outfitId,
        name: _name,
        category: _category,
        color: _color,
        notes: _notes,
        imagePath: _imagePath,
      );
      
      return outfit;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset form
  void reset() {
    _name = null;
    _category = null;
    _color = null;
    _notes = null;
    _imagePath = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
