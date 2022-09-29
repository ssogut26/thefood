// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealList _$MealListFromJson(Map<String, dynamic> json) => MealList(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => Meals.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealListToJson(MealList instance) => <String, dynamic>{
      'meals': instance.meals,
    };
