import '../../domain/entities/outfit_item.dart';
import '../../domain/entities/mix_match_combo.dart';
import '../../domain/repositories/mix_match_repository.dart';
import '../datasources/wardrobe_remote_datasource.dart';
import '../../../../shared/data/cache_manager.dart';
import '../models/mix_match_combo_model.dart';
import 'package:uuid/uuid.dart';

/// Implementation of MixMatchRepository
class MixMatchRepositoryImpl implements MixMatchRepository {
  final WardrobeRemoteDataSource remoteDataSource;
  final CacheManager cacheManager;
  final Uuid uuid = const Uuid();

  MixMatchRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheManager,
  });

  @override
  Future<List<OutfitItem>> listTops() async {
    try {
      final outfits = await remoteDataSource.listOutfits(category: 'tops');
      return outfits.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<OutfitItem>> listBottoms() async {
    try {
      final outfits = await remoteDataSource.listOutfits(category: 'bottoms');
      return outfits.map((m) => m.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MixMatchCombo> saveCombo({
    required String name,
    required String topId,
    required String bottomId,
    String? compatibilityNote,
  }) async {
    try {
      final comboId = uuid.v4();
      final combo = MixMatchComboModel(
        id: comboId,
        name: name,
        topId: topId,
        bottomId: bottomId,
        compatibilityNote: compatibilityNote,
        createdAt: DateTime.now(),
      );

      await cacheManager.saveCombo(combo.toJson());
      return combo.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MixMatchCombo>> listSavedCombos() async {
    try {
      final cachedCombos = cacheManager.getSavedCombos();
      return cachedCombos
          .map((json) => MixMatchComboModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSavedCombo(String comboId) async {
    try {
      await cacheManager.deleteCombo(comboId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String calculateCompatibility(OutfitItem top, OutfitItem bottom) {
    // Simple rule-based compatibility checking
    final topColor = top.color.toLowerCase();
    final bottomColor = bottom.color.toLowerCase();
    final topNotes = top.notes?.toLowerCase() ?? '';
    final bottomNotes = bottom.notes?.toLowerCase() ?? '';

    // Same color = Monochrome
    if (topColor == bottomColor) {
      return 'Monochrome look - Very cohesive!';
    }

    // Pattern clash detection
    final hasPatternKeywords = ['pattern', 'stripe', 'dot', 'print', 'floral'];
    final topHasPattern = hasPatternKeywords.any((keyword) => 
      topNotes.contains(keyword) || top.name.toLowerCase().contains(keyword));
    final bottomHasPattern = hasPatternKeywords.any((keyword) => 
      bottomNotes.contains(keyword) || bottom.name.toLowerCase().contains(keyword));

    if (topHasPattern && bottomHasPattern) {
      return 'Pattern clash risk - Mix carefully!';
    }

    // Default
    return 'Balanced look - Good combination!';
  }
}
