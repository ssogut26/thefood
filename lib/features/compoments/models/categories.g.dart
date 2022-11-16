// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 2;

  @override
  Categories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categories(
      categories: (fields[0] as List?)?.cast<MealCategory>(),
    );
  }

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealCategoryAdapter extends TypeAdapter<MealCategory> {
  @override
  final int typeId = 3;

  @override
  MealCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealCategory(
      idCategory: fields[0] as String?,
      strCategory: fields[1] as String?,
      strCategoryThumb: fields[2] as String?,
      strCategoryDescription: fields[3] as String?,
      statusCode: fields[4] as StatusCode?,
    );
  }

  @override
  void write(BinaryWriter writer, MealCategory obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idCategory)
      ..writeByte(1)
      ..write(obj.strCategory)
      ..writeByte(2)
      ..write(obj.strCategoryThumb)
      ..writeByte(3)
      ..write(obj.strCategoryDescription)
      ..writeByte(4)
      ..write(obj.statusCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
