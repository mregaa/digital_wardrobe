import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.value,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      value: category.value,
    );
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      value: value,
    );
  }
}
