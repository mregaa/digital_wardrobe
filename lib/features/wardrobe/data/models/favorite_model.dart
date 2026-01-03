import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/favorite.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.outfitId,
    required super.userId,
    required super.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  factory FavoriteModel.fromEntity(Favorite favorite) {
    return FavoriteModel(
      id: favorite.id,
      outfitId: favorite.outfitId,
      userId: favorite.userId,
      createdAt: favorite.createdAt,
    );
  }

  Favorite toEntity() {
    return Favorite(
      id: id,
      outfitId: outfitId,
      userId: userId,
      createdAt: createdAt,
    );
  }
}
