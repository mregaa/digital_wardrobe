enum OutfitCategory {
  tops,
  bottoms,
  outerwear,
  shoes,
  accessories,
}

/// Extension methods for OutfitCategory enum
/// 
/// IMPORTANT: Always use `fromAny()` when parsing category from JSON/API
/// to avoid crashes from unexpected data formats (string vs int, unknown values, etc.)
extension OutfitCategoryExtension on OutfitCategory {
  String get displayName {
    switch (this) {
      case OutfitCategory.tops:
        return 'Tops';
      case OutfitCategory.bottoms:
        return 'Bottoms';
      case OutfitCategory.outerwear:
        return 'Outerwear';
      case OutfitCategory.shoes:
        return 'Shoes';
      case OutfitCategory.accessories:
        return 'Accessories';
    }
  }

  String get value {
    return name;
  }

  /// Parse from string (legacy fromString method)
  static OutfitCategory fromString(String value) {
    return OutfitCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OutfitCategory.tops,
    );
  }

  /// Safe parsing from any dynamic value (string, int, or null)
  /// This method handles:
  /// - String names: "tops", "TOPS", "Tops" -> OutfitCategory.tops
  /// - Int indices: 0 -> OutfitCategory.tops, 1 -> OutfitCategory.bottoms
  /// - Unknown/invalid values -> fallback to OutfitCategory.tops
  /// - Null values -> fallback to OutfitCategory.tops
  static OutfitCategory fromAny(dynamic value, {OutfitCategory fallback = OutfitCategory.tops}) {
    // Handle null
    if (value == null) {
      return fallback;
    }

    // Handle int index (legacy format or enum index)
    if (value is int) {
      if (value >= 0 && value < OutfitCategory.values.length) {
        return OutfitCategory.values[value];
      }
      // Invalid index - return fallback
      return fallback;
    }

    // Handle string name
    if (value is String) {
      final normalizedValue = value.trim().toLowerCase();
      
      // Try exact match first
      try {
        return OutfitCategory.values.firstWhere(
          (e) => e.name.toLowerCase() == normalizedValue,
        );
      } catch (_) {
        // No match found - return fallback
        return fallback;
      }
    }

    // Unknown type - return fallback
    return fallback;
  }
}
