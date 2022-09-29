import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thefood/models/meals.dart';

part 'meal_list.g.dart';

@JsonSerializable()
class MealList with EquatableMixin {
  MealList({
    this.meals,
  });
  factory MealList.fromJson(Map<String, dynamic> json) => _$MealListFromJson(json);
  final List<Meals>? meals;
  Map<String, dynamic> toJson() => _$MealListToJson(this);

  @override
  List<Object?> get props => [meals];
}
