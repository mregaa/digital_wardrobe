import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for caching data locally
class CacheManager {
  final SharedPreferences _prefs;
  
  static const String _outfitsKey = 'cached_outfits';
  static const String _favoritesKey = 'cached_favorites';
  static const String _combosKey = 'saved_combos';
  static const String _lastCacheTimeKey = 'last_cache_time';
  
  CacheManager(this._prefs);
  
  /// Initialize cache manager
  static Future<CacheManager> init() async {
    final prefs = await SharedPreferences.getInstance();
    return CacheManager(prefs);
  }
  
  // ==================== Outfits Cache ====================
  
  /// Cache outfits list
  Future<void> cacheOutfits(List<Map<String, dynamic>> outfits) async {
    final jsonString = jsonEncode(outfits);
    await _prefs.setString(_outfitsKey, jsonString);
    await _updateCacheTime();
  }
  
  /// Get cached outfits
  List<Map<String, dynamic>>? getCachedOutfits() {
    final jsonString = _prefs.getString(_outfitsKey);
    if (jsonString == null) return null;
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return null;
    }
  }
  
  /// Clear outfits cache
  Future<void> clearOutfitsCache() async {
    await _prefs.remove(_outfitsKey);
  }
  
  // ==================== Favorites Cache ====================
  
  /// Cache favorites list
  Future<void> cacheFavorites(List<String> favoriteIds) async {
    await _prefs.setStringList(_favoritesKey, favoriteIds);
  }
  
  /// Get cached favorites
  List<String>? getCachedFavorites() {
    return _prefs.getStringList(_favoritesKey);
  }
  
  /// Toggle favorite in cache
  Future<void> toggleFavoriteInCache(String outfitId) async {
    final favorites = getCachedFavorites() ?? [];
    if (favorites.contains(outfitId)) {
      favorites.remove(outfitId);
    } else {
      favorites.add(outfitId);
    }
    await cacheFavorites(favorites);
  }
  
  /// Clear favorites cache
  Future<void> clearFavoritesCache() async {
    await _prefs.remove(_favoritesKey);
  }
  
  // ==================== Mix & Match Combos ====================
  
  /// Save a mix & match combo
  Future<void> saveCombo(Map<String, dynamic> combo) async {
    final combos = getSavedCombos();
    combos.add(combo);
    final jsonString = jsonEncode(combos);
    await _prefs.setString(_combosKey, jsonString);
  }
  
  /// Get all saved combos
  List<Map<String, dynamic>> getSavedCombos() {
    final jsonString = _prefs.getString(_combosKey);
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
  
  /// Delete a combo by ID
  Future<void> deleteCombo(String comboId) async {
    final combos = getSavedCombos();
    combos.removeWhere((combo) => combo['id'] == comboId);
    final jsonString = jsonEncode(combos);
    await _prefs.setString(_combosKey, jsonString);
  }
  
  /// Clear all saved combos
  Future<void> clearAllCombos() async {
    await _prefs.remove(_combosKey);
  }
  
  // ==================== Cache Validity ====================
  
  /// Update last cache time
  Future<void> _updateCacheTime() async {
    await _prefs.setInt(_lastCacheTimeKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Get last cache time
  DateTime? getLastCacheTime() {
    final timestamp = _prefs.getInt(_lastCacheTimeKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
  
  /// Check if cache is valid (within 24 hours)
  bool isCacheValid({Duration validity = const Duration(hours: 24)}) {
    final lastCacheTime = getLastCacheTime();
    if (lastCacheTime == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(lastCacheTime);
    return difference < validity;
  }
  
  /// Clear all cache
  Future<void> clearAll() async {
    await clearOutfitsCache();
    await clearFavoritesCache();
    await clearAllCombos();
    await _prefs.remove(_lastCacheTimeKey);
  }
}
