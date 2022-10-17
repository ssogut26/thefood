import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable()
class MealCategory with EquatableMixin {
  MealCategory({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
    this.statusCode,
  });
  factory MealCategory.fromJson(Map<String, dynamic> json) =>
      _$MealCategoryFromJson(json);
  String? idCategory;
  String? strCategory;
  String? strCategoryThumb;
  String? strCategoryDescription;
  final StatusCode? statusCode;
  Map<String, dynamic> toJson() => _$MealCategoryToJson(this);

  @override
  List<Object?> get props =>
      [idCategory, strCategory, strCategoryThumb, strCategoryDescription, statusCode];

  MealCategory copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
    StatusCode? statusCode,
  }) {
    return MealCategory(
      idCategory: idCategory ?? this.idCategory,
      strCategory: strCategory ?? this.strCategory,
      strCategoryThumb: strCategoryThumb ?? this.strCategoryThumb,
      strCategoryDescription: strCategoryDescription ?? this.strCategoryDescription,
      statusCode: statusCode ?? this.statusCode,
    );
  }
}

enum StatusCode {
  @JsonValue(200)
  success,
  @JsonValue(500)
  failed,
  @JsonValue(404)
  notFound,
  @JsonValue(101)
  invalidKey,
}
