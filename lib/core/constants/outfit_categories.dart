enum OutfitCategory {
  tops,
  bottoms,
  outerwear,
  shoes,
  accessories,
}

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

  static OutfitCategory fromString(String value) {
    return OutfitCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OutfitCategory.tops,
    );
  }
}
