import 'package:equatable/equatable.dart';

/// Category domain entity
class Category extends Equatable {
  final String id;
  final String name;
  final String value;

  const Category({
    required this.id,
    required this.name,
    required this.value,
  });

  @override
  List<Object> get props => [id, name, value];
}
