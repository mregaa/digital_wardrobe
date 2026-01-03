import '../../wardrobe/domain/entities/outfit_item.dart';

/// Service for generating outfit recommendations based on compatibility rules
class RecommendationService {
  /// Generate outfit combinations from available items
  List<OutfitCombo> generateRecommendations(List<OutfitItem> allOutfits, {int maxResults = 10}) {
    // Separate by category
    final tops = allOutfits.where((o) => o.category.toLowerCase() == 'tops').toList();
    final bottoms = allOutfits.where((o) => o.category.toLowerCase() == 'bottoms').toList();
    final outerwear = allOutfits.where((o) => o.category.toLowerCase() == 'outerwear').toList();
    final shoes = allOutfits.where((o) => o.category.toLowerCase() == 'shoes').toList();

    if (tops.isEmpty || bottoms.isEmpty) {
      return [];
    }

    final combos = <OutfitCombo>[];

    // Generate combinations: top + bottom + optional extras
    for (final top in tops) {
      for (final bottom in bottoms) {
        // Calculate compatibility score
        final score = _calculateCompatibility(
          top: top,
          bottom: bottom,
          outerwear: outerwear.isNotEmpty ? outerwear.first : null,
          shoes: shoes.isNotEmpty ? shoes.first : null,
        );

        final items = [top, bottom];
        
        // Add optional items for variety
        if (outerwear.isNotEmpty && combos.length % 3 == 0) {
          items.add(outerwear.first);
        }
        if (shoes.isNotEmpty) {
          items.add(shoes.first);
        }

        combos.add(OutfitCombo(
          items: items,
          score: score,
          reason: _getCompatibilityReason(top, bottom),
        ));
      }
    }

    // Sort by score and return top results
    combos.sort((a, b) => b.score.compareTo(a.score));
    return combos.take(maxResults).toList();
  }

  /// Calculate compatibility score (0-100)
  int _calculateCompatibility({
    required OutfitItem top,
    required OutfitItem bottom,
    OutfitItem? outerwear,
    OutfitItem? shoes,
  }) {
    int score = 50; // Base score

    final topColor = top.color.toLowerCase();
    final bottomColor = bottom.color.toLowerCase();

    // Monochrome bonus (same color)
    if (topColor == bottomColor) {
      score += 25;
    }

    // Neutral colors always work
    final neutrals = ['black', 'white', 'grey', 'gray', 'beige', 'navy'];
    if (neutrals.contains(topColor) || neutrals.contains(bottomColor)) {
      score += 15;
    }

    // Classic combinations
    if ((topColor == 'white' && bottomColor == 'black') ||
        (topColor == 'black' && bottomColor == 'white') ||
        (topColor == 'navy' && bottomColor == 'beige') ||
        (topColor == 'white' && bottomColor == 'blue')) {
      score += 20;
    }

    // Pattern check - avoid too many patterns
    final hasTopPattern = top.notes?.toLowerCase().contains('pattern') ?? false;
    final hasBottomPattern = bottom.notes?.toLowerCase().contains('pattern') ?? false;
    final hasOuterwearPattern = outerwear?.notes?.toLowerCase().contains('pattern') ?? false;

    final patternCount = [hasTopPattern, hasBottomPattern, hasOuterwearPattern]
        .where((p) => p)
        .length;

    if (patternCount == 0) {
      score += 10; // Clean, solid look
    } else if (patternCount == 1) {
      score += 15; // Perfect - one statement piece
    } else if (patternCount >= 2) {
      score -= 20; // Too busy
    }

    // Bonus for complementary colors
    if (_areComplementary(topColor, bottomColor)) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// Check if two colors are complementary
  bool _areComplementary(String color1, String color2) {
    final complementaryPairs = {
      'blue': ['orange', 'brown'],
      'red': ['green'],
      'yellow': ['purple'],
      'navy': ['beige', 'brown'],
    };

    return complementaryPairs[color1]?.contains(color2) ?? false;
  }

  /// Get human-readable compatibility reason
  String _getCompatibilityReason(OutfitItem top, OutfitItem bottom) {
    final topColor = top.color.toLowerCase();
    final bottomColor = bottom.color.toLowerCase();

    if (topColor == bottomColor) {
      return 'Monochrome elegance';
    }

    final neutrals = ['black', 'white', 'grey', 'gray', 'beige'];
    if (neutrals.contains(topColor) && neutrals.contains(bottomColor)) {
      return 'Classic neutral pairing';
    }

    if ((topColor == 'white' && bottomColor == 'black') ||
        (topColor == 'black' && bottomColor == 'white')) {
      return 'Timeless black & white';
    }

    if ((topColor == 'navy' && bottomColor == 'beige') ||
        (topColor == 'beige' && bottomColor == 'navy')) {
      return 'Sophisticated contrast';
    }

    if (_areComplementary(topColor, bottomColor)) {
      return 'Complementary colors';
    }

    return 'Balanced combination';
  }
}

/// Represents a recommended outfit combination
class OutfitCombo {
  final List<OutfitItem> items;
  final int score;
  final String reason;

  OutfitCombo({
    required this.items,
    required this.score,
    required this.reason,
  });

  OutfitItem? get top => items.firstWhere(
        (item) => item.category.toLowerCase() == 'tops',
        orElse: () => items.first,
      );

  OutfitItem? get bottom => items.firstWhere(
        (item) => item.category.toLowerCase() == 'bottoms',
        orElse: () => items.length > 1 ? items[1] : items.first,
      );

  List<OutfitItem> get extras => items.where(
        (item) => item.category.toLowerCase() != 'tops' && 
                  item.category.toLowerCase() != 'bottoms',
      ).toList();
}
