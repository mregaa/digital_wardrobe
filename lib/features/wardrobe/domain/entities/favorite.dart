import 'package:equatable/equatable.dart';

/// Favorite domain entity
class Favorite extends Equatable {
  final String id;
  final String outfitId;
  final String userId;
  final DateTime createdAt;

  const Favorite({
    required this.id,
    required this.outfitId,
    required this.userId,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, outfitId, userId, createdAt];
}
