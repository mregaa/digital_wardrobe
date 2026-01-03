import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/mix_match_combo.dart';
import '../../../../core/constants/app_constants.dart';

part 'mix_match_combo_model.g.dart';

@JsonSerializable()
class MixMatchComboModel extends MixMatchCombo {
  const MixMatchComboModel({
    required super.id,
    required super.name,
    required super.topId,
    super.topImageUrl,
    super.topName,
    required super.bottomId,
    super.bottomImageUrl,
    super.bottomName,
    super.compatibilityNote,
    required super.createdAt,
    super.updatedAt,
  });

  factory MixMatchComboModel.fromJson(Map<String, dynamic> json) {
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

    return MixMatchComboModel(
      id: json['id'] as String,
      name: json['name'] as String,
      topId: json['topId'] as String,
      topImageUrl: normalizeImageUrl(json['topImageUrl']),
      topName: json['topName'] as String?,
      bottomId: json['bottomId'] as String,
      bottomImageUrl: normalizeImageUrl(json['bottomImageUrl']),
      bottomName: json['bottomName'] as String?,
      compatibilityNote: json['compatibilityNote'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => _$MixMatchComboModelToJson(this);

  factory MixMatchComboModel.fromEntity(MixMatchCombo combo) {
    return MixMatchComboModel(
      id: combo.id,
      name: combo.name,
      topId: combo.topId,
      topImageUrl: combo.topImageUrl,
      topName: combo.topName,
      bottomId: combo.bottomId,
      bottomImageUrl: combo.bottomImageUrl,
      bottomName: combo.bottomName,
      compatibilityNote: combo.compatibilityNote,
      createdAt: combo.createdAt,
      updatedAt: combo.updatedAt,
    );
  }

  MixMatchCombo toEntity() {
    return MixMatchCombo(
      id: id,
      name: name,
      topId: topId,
      topImageUrl: topImageUrl,
      topName: topName,
      bottomId: bottomId,
      bottomImageUrl: bottomImageUrl,
      bottomName: bottomName,
      compatibilityNote: compatibilityNote,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  MixMatchComboModel copyWithModel({
    String? id,
    String? name,
    String? topId,
    String? topImageUrl,
    String? topName,
    String? bottomId,
    String? bottomImageUrl,
    String? bottomName,
    String? compatibilityNote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MixMatchComboModel(
      id: id ?? this.id,
      name: name ?? this.name,
      topId: topId ?? this.topId,
      topImageUrl: topImageUrl ?? this.topImageUrl,
      topName: topName ?? this.topName,
      bottomId: bottomId ?? this.bottomId,
      bottomImageUrl: bottomImageUrl ?? this.bottomImageUrl,
      bottomName: bottomName ?? this.bottomName,
      compatibilityNote: compatibilityNote ?? this.compatibilityNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
