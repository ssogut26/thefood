// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingredients _$IngredientsFromJson(Map<String, dynamic> json) => Ingredients(
      ingredients: (json['meals'] as List<dynamic>?)
          ?.map((e) => MealsIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IngredientsToJson(Ingredients instance) => <String, dynamic>{
      'meals': instance.ingredients,
    };

MealsIngredient _$MealsIngredientFromJson(Map<String, dynamic> json) => MealsIngredient(
      idIngredient: json['idIngredient'] as String?,
      strIngredient: json['strIngredient'] as String,
      strDescription: json['strDescription'] as String?,
      strType: json['strType'] as String?,
    );

Map<String, dynamic> _$MealsIngredientToJson(MealsIngredient instance) =>
    <String, dynamic>{
      'idIngredient': instance.idIngredient,
      'strIngredient': instance.strIngredient,
      'strDescription': instance.strDescription,
      'strType': instance.strType,
    };
