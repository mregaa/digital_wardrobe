import '../entities/outfit_item.dart';
import '../entities/mix_match_combo.dart';

/// Mix & Match repository interface
abstract class MixMatchRepository {
  /// Get all tops (filtered by category)
  Future<List<OutfitItem>> listTops();

  /// Get all bottoms (filtered by category)
  Future<List<OutfitItem>> listBottoms();

  /// Save a new combo locally
  Future<MixMatchCombo> saveCombo({
    required String name,
    required String topId,
    required String bottomId,
    String? compatibilityNote,
  });

  /// Get all saved combos
  Future<List<MixMatchCombo>> listSavedCombos();

  /// Delete a saved combo
  Future<void> deleteSavedCombo(String comboId);

  /// Calculate compatibility note between two items
  String calculateCompatibility(OutfitItem top, OutfitItem bottom);
}
