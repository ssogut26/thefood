import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thefood/models/category.dart';

part 'categories.g.dart';

@JsonSerializable()
class Categories with EquatableMixin {
  Categories({
    this.categories,
  });
  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);
  @JsonKey(name: 'categories')
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
  final List<MealCategory>? categories;

  @override
  List<Object?> get props => [categories];

  Categories copyWith({
    List<MealCategory>? categories,
  }) {
    return Categories(
      categories: categories ?? this.categories,
    );
  }
}
