// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => MealsArea.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'meals': instance.meals,
    };

MealsArea _$MealsAreaFromJson(Map<String, dynamic> json) => MealsArea(
      strArea: json['strArea'] as String?,
    );

Map<String, dynamic> _$MealsAreaToJson(MealsArea instance) => <String, dynamic>{
      'strArea': instance.strArea,
    };
