import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/outfit_item.dart';
import '../../../../core/constants/app_constants.dart';

part 'outfit_model.g.dart';

@JsonSerializable()
class OutfitModel extends OutfitItem {
  const OutfitModel({
    required super.id,
    required super.name,
    required super.category,
    required super.color,
    super.notes,
    super.imageUrl,
    super.isFavorite,
    required super.userId,
    required super.createdAt,
    super.updatedAt,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    // Handle flexible date parsing
    DateTime parseDateTime(dynamic value) {
      if (value == null) throw FormatException('DateTime cannot be null');
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      throw FormatException('Invalid DateTime format: $value');
    }

    DateTime? parseOptionalDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return null;
    }

    // Safe category parsing - handles both string and int formats
    String parseCategory(dynamic value) {
      if (value == null) return 'tops';
      if (value is String) return value.toLowerCase();
      if (value is int) {
        // Backend mistakenly sent int index - convert to string safely
        final categories = ['tops', 'bottoms', 'outerwear', 'shoes', 'accessories'];
        if (value >= 0 && value < categories.length) {
          return categories[value];
        }
        return 'tops'; // fallback for invalid index
      }
      return 'tops'; // fallback for unexpected type
    }

    // Normalize image URL - convert relative paths to full URLs
    String? normalizeImageUrl(dynamic value) {
      if (value == null) return null;
      
      final imageUrl = value.toString().trim();
      if (imageUrl.isEmpty) return null;
      
      // Already a full URL
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return imageUrl;
      }
      
      // Relative path - convert to full URL
      if (imageUrl.startsWith('/')) {
        // Remove trailing slash from base URL if present to avoid double slashes
        final base = AppConstants.imageBaseUrl.endsWith('/')
            ? AppConstants.imageBaseUrl.substring(0, AppConstants.imageBaseUrl.length - 1)
            : AppConstants.imageBaseUrl;
        return '$base$imageUrl';
      }
      
      // Path doesn't start with / - add it
      final base = AppConstants.imageBaseUrl.endsWith('/')
          ? AppConstants.imageBaseUrl.substring(0, AppConstants.imageBaseUrl.length - 1)
          : AppConstants.imageBaseUrl;
      return '$base/$imageUrl';
    }

    return OutfitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: parseCategory(json['category']),
      color: json['color'] as String? ?? '',
      notes: json['notes'] as String?,
      imageUrl: normalizeImageUrl(json['imageUrl']),
      isFavorite: json['isFavorite'] as bool? ?? false,
      userId: json['userId'] as String,
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseOptionalDateTime(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => _$OutfitModelToJson(this);

  factory OutfitModel.fromEntity(OutfitItem outfit) {
    return OutfitModel(
      id: outfit.id,
      name: outfit.name,
      category: outfit.category,
      color: outfit.color,
      notes: outfit.notes,
      imageUrl: outfit.imageUrl,
      isFavorite: outfit.isFavorite,
      userId: outfit.userId,
      createdAt: outfit.createdAt,
      updatedAt: outfit.updatedAt,
    );
  }

  OutfitItem toEntity() {
    return OutfitItem(
      id: id,
      name: name,
      category: category,
      color: color,
      notes: notes,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  OutfitModel copyWithModel({
    String? id,
    String? name,
    String? category,
    String? color,
    String? notes,
    String? imageUrl,
    bool? isFavorite,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OutfitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
