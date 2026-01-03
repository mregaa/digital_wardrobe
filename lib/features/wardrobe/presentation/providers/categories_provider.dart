import 'package:flutter/foundation.dart';
import '../../domain/entities/category.dart' as wardrobe;
import '../../domain/repositories/wardrobe_repository.dart';

/// Provider for outfit categories
class CategoriesProvider with ChangeNotifier {
  final WardrobeRepository repository;

  CategoriesProvider({required this.repository});

  List<wardrobe.Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<wardrobe.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await repository.listCategories();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get category by value
  wardrobe.Category? getCategoryByValue(String value) {
    try {
      return _categories.firstWhere((c) => c.value == value);
    } catch (e) {
      return null;
    }
  }

  /// Get category name by value
  String getCategoryName(String value) {
    final category = getCategoryByValue(value);
    return category?.name ?? value;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
