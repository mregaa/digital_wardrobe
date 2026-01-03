import 'package:flutter_test/flutter_test.dart';
import 'package:digital_wardrobe/core/constants/outfit_categories.dart';

void main() {
  group('OutfitCategory.fromAny - Safe Enum Parsing', () {
    test('should parse valid string names (lowercase)', () {
      expect(OutfitCategoryExtension.fromAny('tops'), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny('bottoms'), OutfitCategory.bottoms);
      expect(OutfitCategoryExtension.fromAny('outerwear'), OutfitCategory.outerwear);
      expect(OutfitCategoryExtension.fromAny('shoes'), OutfitCategory.shoes);
      expect(OutfitCategoryExtension.fromAny('accessories'), OutfitCategory.accessories);
    });

    test('should parse valid string names (case-insensitive)', () {
      expect(OutfitCategoryExtension.fromAny('TOPS'), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny('Bottoms'), OutfitCategory.bottoms);
      expect(OutfitCategoryExtension.fromAny('OuterWear'), OutfitCategory.outerwear);
      expect(OutfitCategoryExtension.fromAny('SHOES'), OutfitCategory.shoes);
      expect(OutfitCategoryExtension.fromAny('Accessories'), OutfitCategory.accessories);
    });

    test('should parse valid int indices', () {
      expect(OutfitCategoryExtension.fromAny(0), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(1), OutfitCategory.bottoms);
      expect(OutfitCategoryExtension.fromAny(2), OutfitCategory.outerwear);
      expect(OutfitCategoryExtension.fromAny(3), OutfitCategory.shoes);
      expect(OutfitCategoryExtension.fromAny(4), OutfitCategory.accessories);
    });

    test('should handle unknown string values with fallback', () {
      expect(OutfitCategoryExtension.fromAny('unknown'), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny('invalid_category'), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(''), OutfitCategory.tops);
    });

    test('should handle invalid int indices with fallback', () {
      expect(OutfitCategoryExtension.fromAny(-1), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(999), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(100), OutfitCategory.tops);
    });

    test('should handle null values with fallback', () {
      expect(OutfitCategoryExtension.fromAny(null), OutfitCategory.tops);
    });

    test('should respect custom fallback parameter', () {
      expect(
        OutfitCategoryExtension.fromAny('unknown', fallback: OutfitCategory.accessories),
        OutfitCategory.accessories,
      );
      expect(
        OutfitCategoryExtension.fromAny(null, fallback: OutfitCategory.shoes),
        OutfitCategory.shoes,
      );
    });

    test('should handle whitespace in strings', () {
      expect(OutfitCategoryExtension.fromAny('  tops  '), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(' bottoms '), OutfitCategory.bottoms);
    });

    test('should not crash on unexpected types', () {
      // These should return fallback instead of crashing
      expect(OutfitCategoryExtension.fromAny(true), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny(3.14), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny([]), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromAny({}), OutfitCategory.tops);
    });
  });

  group('OutfitCategory.fromString - Legacy Method', () {
    test('should still work for backward compatibility', () {
      expect(OutfitCategoryExtension.fromString('tops'), OutfitCategory.tops);
      expect(OutfitCategoryExtension.fromString('bottoms'), OutfitCategory.bottoms);
    });

    test('should fallback to tops for unknown values', () {
      expect(OutfitCategoryExtension.fromString('unknown'), OutfitCategory.tops);
    });
  });
}
