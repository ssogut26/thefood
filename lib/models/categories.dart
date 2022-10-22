import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Categories with EquatableMixin {
  Categories({
    this.categories,
  });
  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);
  @JsonKey(name: 'categories')
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
  @HiveField(0)
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
@HiveType(typeId: 3)
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
  @HiveField(0)
  String? idCategory;
  @HiveField(1)
  String? strCategory;
  @HiveField(2)
  String? strCategoryThumb;
  @HiveField(3)
  String? strCategoryDescription;
  @HiveField(4)
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
