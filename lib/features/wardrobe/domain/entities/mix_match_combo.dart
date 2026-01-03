import 'package:equatable/equatable.dart';

/// MixMatchCombo domain entity
class MixMatchCombo extends Equatable {
  final String id;
  final String name;
  final String topId;
  final String? topImageUrl;
  final String? topName;
  final String bottomId;
  final String? bottomImageUrl;
  final String? bottomName;
  final String? compatibilityNote;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MixMatchCombo({
    required this.id,
    required this.name,
    required this.topId,
    this.topImageUrl,
    this.topName,
    required this.bottomId,
    this.bottomImageUrl,
    this.bottomName,
    this.compatibilityNote,
    required this.createdAt,
    this.updatedAt,
  });

  MixMatchCombo copyWith({
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
    return MixMatchCombo(
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

  @override
  List<Object?> get props => [
        id,
        name,
        topId,
        topImageUrl,
        topName,
        bottomId,
        bottomImageUrl,
        bottomName,
        compatibilityNote,
        createdAt,
        updatedAt,
      ];
}
