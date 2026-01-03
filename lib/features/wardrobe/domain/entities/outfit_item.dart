import 'package:equatable/equatable.dart';

/// OutfitItem domain entity
class OutfitItem extends Equatable {
  final String id;
  final String name;
  final String category;
  final String color;
  final String? notes;
  final String? imageUrl;
  final bool isFavorite;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const OutfitItem({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    this.notes,
    this.imageUrl,
    this.isFavorite = false,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  OutfitItem copyWith({
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
    return OutfitItem(
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

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        color,
        notes,
        imageUrl,
        isFavorite,
        userId,
        createdAt,
        updatedAt,
      ];
}
