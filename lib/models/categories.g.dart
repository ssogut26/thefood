// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categories _$CategoriesFromJson(Map<String, dynamic> json) => Categories(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesToJson(Categories instance) =>
    <String, dynamic>{
      'categories': instance.categories,
    };

MealCategory _$MealCategoryFromJson(Map<String, dynamic> json) => MealCategory(
      idCategory: json['idCategory'] as String?,
      strCategory: json['strCategory'] as String?,
      strCategoryThumb: json['strCategoryThumb'] as String?,
      strCategoryDescription: json['strCategoryDescription'] as String?,
      statusCode: $enumDecodeNullable(_$StatusCodeEnumMap, json['statusCode']),
    );

Map<String, dynamic> _$MealCategoryToJson(MealCategory instance) =>
    <String, dynamic>{
      'idCategory': instance.idCategory,
      'strCategory': instance.strCategory,
      'strCategoryThumb': instance.strCategoryThumb,
      'strCategoryDescription': instance.strCategoryDescription,
      'statusCode': _$StatusCodeEnumMap[instance.statusCode],
    };

const _$StatusCodeEnumMap = {
  StatusCode.success: 200,
  StatusCode.failed: 500,
  StatusCode.notFound: 404,
  StatusCode.invalidKey: 101,
};
