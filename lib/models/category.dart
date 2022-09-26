import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class MealCategory with EquatableMixin {
  MealCategory({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });
  factory MealCategory.fromJson(Map<String, dynamic> json) =>
      _$MealCategoryFromJson(json);
  String? idCategory;
  String? strCategory;
  String? strCategoryThumb;
  String? strCategoryDescription;

  Map<String, dynamic> toJson() => _$MealCategoryToJson(this);

  @override
  List<Object?> get props =>
      [idCategory, strCategory, strCategoryThumb, strCategoryDescription];

  MealCategory copyWith({
    String? idCategory,
    String? strCategory,
    String? strCategoryThumb,
    String? strCategoryDescription,
  }) {
    return MealCategory(
      idCategory: idCategory ?? this.idCategory,
      strCategory: strCategory ?? this.strCategory,
      strCategoryThumb: strCategoryThumb ?? this.strCategoryThumb,
      strCategoryDescription: strCategoryDescription ?? this.strCategoryDescription,
    );
  }
}
