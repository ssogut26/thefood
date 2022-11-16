import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredients.g.dart';

@JsonSerializable()
class Ingredients with EquatableMixin {
  Ingredients({
    this.meals,
  });
  factory Ingredients.fromJson(Map<String, dynamic> json) => _$IngredientsFromJson(json);
  final List<MealsIngredient>? meals;
  Map<String, dynamic> toJson() => _$IngredientsToJson(this);

  @override
  List<Object?> get props => [meals];
}

@JsonSerializable()
class MealsIngredient with EquatableMixin {
  MealsIngredient({
    this.idIngredient,
    this.strIngredient,
    this.strDescription,
    this.strType,
  });
  factory MealsIngredient.fromJson(Map<String, dynamic> json) =>
      _$MealsIngredientFromJson(json);
  String? idIngredient;
  String? strIngredient;
  String? strDescription;
  String? strType;
  Map<String, dynamic> toJson() => _$MealsIngredientToJson(this);

  @override
  List<Object?> get props => [idIngredient, strIngredient, strDescription, strType];
}
