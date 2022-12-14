// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meals.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 0;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      meals: (fields[0] as List?)?.cast<Meals>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.meals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealsAdapter extends TypeAdapter<Meals> {
  @override
  final int typeId = 1;

  @override
  Meals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meals(
      idMeal: fields[1] as String?,
      strMeal: fields[2] as String?,
      strDrinkAlternate: fields[3] as String?,
      strCategory: fields[4] as String?,
      strArea: fields[5] as String?,
      strInstructions: fields[6] as String?,
      strMealThumb: fields[7] as String?,
      strTags: fields[8] as String?,
      strYoutube: fields[9] as String?,
      strIngredient1: fields[10] as String?,
      strIngredient2: fields[11] as String?,
      strIngredient3: fields[12] as String?,
      strIngredient4: fields[13] as String?,
      strIngredient5: fields[14] as String?,
      strIngredient6: fields[15] as String?,
      strIngredient7: fields[16] as String?,
      strIngredient8: fields[17] as String?,
      strIngredient9: fields[18] as String?,
      strIngredient10: fields[19] as String?,
      strIngredient11: fields[20] as String?,
      strIngredient12: fields[21] as String?,
      strIngredient13: fields[22] as String?,
      strIngredient14: fields[23] as String?,
      strIngredient15: fields[24] as String?,
      strIngredient16: fields[25] as String?,
      strIngredient17: fields[26] as String?,
      strIngredient18: fields[27] as String?,
      strIngredient19: fields[28] as String?,
      strIngredient20: fields[29] as String?,
      strIngredients: (fields[0] as List?)?.cast<String?>(),
      strMeasure1: fields[30] as String?,
      strMeasure2: fields[31] as String?,
      strMeasure3: fields[32] as String?,
      strMeasure4: fields[33] as String?,
      strMeasure5: fields[34] as String?,
      strMeasure6: fields[35] as String?,
      strMeasure7: fields[36] as String?,
      strMeasure8: fields[37] as String?,
      strMeasure9: fields[38] as String?,
      strMeasure10: fields[39] as String?,
      strMeasure11: fields[40] as String?,
      strMeasure12: fields[41] as String?,
      strMeasure13: fields[42] as String?,
      strMeasure14: fields[43] as String?,
      strMeasure15: fields[44] as String?,
      strMeasure16: fields[45] as String?,
      strMeasure17: fields[46] as String?,
      strMeasure18: fields[47] as String?,
      strMeasure19: fields[48] as String?,
      strMeasure20: fields[49] as String?,
      strMeasures: (fields[54] as List?)?.cast<String?>(),
      strSource: fields[50] as String?,
      strImageSource: fields[51] as String?,
      dateModified: fields[53] as String?,
      comments: (fields[55] as List?)?.cast<String?>(),
      strCreativeCommonsConfirmed: fields[52] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Meals obj) {
    writer
      ..writeByte(56)
      ..writeByte(0)
      ..write(obj.strIngredients)
      ..writeByte(1)
      ..write(obj.idMeal)
      ..writeByte(2)
      ..write(obj.strMeal)
      ..writeByte(3)
      ..write(obj.strDrinkAlternate)
      ..writeByte(4)
      ..write(obj.strCategory)
      ..writeByte(5)
      ..write(obj.strArea)
      ..writeByte(6)
      ..write(obj.strInstructions)
      ..writeByte(7)
      ..write(obj.strMealThumb)
      ..writeByte(8)
      ..write(obj.strTags)
      ..writeByte(9)
      ..write(obj.strYoutube)
      ..writeByte(10)
      ..write(obj.strIngredient1)
      ..writeByte(11)
      ..write(obj.strIngredient2)
      ..writeByte(12)
      ..write(obj.strIngredient3)
      ..writeByte(13)
      ..write(obj.strIngredient4)
      ..writeByte(14)
      ..write(obj.strIngredient5)
      ..writeByte(15)
      ..write(obj.strIngredient6)
      ..writeByte(16)
      ..write(obj.strIngredient7)
      ..writeByte(17)
      ..write(obj.strIngredient8)
      ..writeByte(18)
      ..write(obj.strIngredient9)
      ..writeByte(19)
      ..write(obj.strIngredient10)
      ..writeByte(20)
      ..write(obj.strIngredient11)
      ..writeByte(21)
      ..write(obj.strIngredient12)
      ..writeByte(22)
      ..write(obj.strIngredient13)
      ..writeByte(23)
      ..write(obj.strIngredient14)
      ..writeByte(24)
      ..write(obj.strIngredient15)
      ..writeByte(25)
      ..write(obj.strIngredient16)
      ..writeByte(26)
      ..write(obj.strIngredient17)
      ..writeByte(27)
      ..write(obj.strIngredient18)
      ..writeByte(28)
      ..write(obj.strIngredient19)
      ..writeByte(29)
      ..write(obj.strIngredient20)
      ..writeByte(30)
      ..write(obj.strMeasure1)
      ..writeByte(31)
      ..write(obj.strMeasure2)
      ..writeByte(32)
      ..write(obj.strMeasure3)
      ..writeByte(33)
      ..write(obj.strMeasure4)
      ..writeByte(34)
      ..write(obj.strMeasure5)
      ..writeByte(35)
      ..write(obj.strMeasure6)
      ..writeByte(36)
      ..write(obj.strMeasure7)
      ..writeByte(37)
      ..write(obj.strMeasure8)
      ..writeByte(38)
      ..write(obj.strMeasure9)
      ..writeByte(39)
      ..write(obj.strMeasure10)
      ..writeByte(40)
      ..write(obj.strMeasure11)
      ..writeByte(41)
      ..write(obj.strMeasure12)
      ..writeByte(42)
      ..write(obj.strMeasure13)
      ..writeByte(43)
      ..write(obj.strMeasure14)
      ..writeByte(44)
      ..write(obj.strMeasure15)
      ..writeByte(45)
      ..write(obj.strMeasure16)
      ..writeByte(46)
      ..write(obj.strMeasure17)
      ..writeByte(47)
      ..write(obj.strMeasure18)
      ..writeByte(48)
      ..write(obj.strMeasure19)
      ..writeByte(49)
      ..write(obj.strMeasure20)
      ..writeByte(50)
      ..write(obj.strSource)
      ..writeByte(51)
      ..write(obj.strImageSource)
      ..writeByte(52)
      ..write(obj.strCreativeCommonsConfirmed)
      ..writeByte(53)
      ..write(obj.dateModified)
      ..writeByte(54)
      ..write(obj.strMeasures)
      ..writeByte(55)
      ..write(obj.comments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => Meals.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'meals': instance.meals,
    };

Meals _$MealsFromJson(Map<String, dynamic> json) => Meals(
      idMeal: json['idMeal'] as String?,
      strMeal: json['strMeal'] as String?,
      strDrinkAlternate: json['strDrinkAlternate'] as String?,
      strCategory: json['strCategory'] as String?,
      strArea: json['strArea'] as String?,
      strInstructions: json['strInstructions'] as String?,
      strMealThumb: json['strMealThumb'] as String?,
      strTags: json['strTags'] as String?,
      strYoutube: json['strYoutube'] as String?,
      strIngredient1: json['strIngredient1'] as String?,
      strIngredient2: json['strIngredient2'] as String?,
      strIngredient3: json['strIngredient3'] as String?,
      strIngredient4: json['strIngredient4'] as String?,
      strIngredient5: json['strIngredient5'] as String?,
      strIngredient6: json['strIngredient6'] as String?,
      strIngredient7: json['strIngredient7'] as String?,
      strIngredient8: json['strIngredient8'] as String?,
      strIngredient9: json['strIngredient9'] as String?,
      strIngredient10: json['strIngredient10'] as String?,
      strIngredient11: json['strIngredient11'] as String?,
      strIngredient12: json['strIngredient12'] as String?,
      strIngredient13: json['strIngredient13'] as String?,
      strIngredient14: json['strIngredient14'] as String?,
      strIngredient15: json['strIngredient15'] as String?,
      strIngredient16: json['strIngredient16'] as String?,
      strIngredient17: json['strIngredient17'] as String?,
      strIngredient18: json['strIngredient18'] as String?,
      strIngredient19: json['strIngredient19'] as String?,
      strIngredient20: json['strIngredient20'] as String?,
      strIngredients: (json['strIngredients'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      strMeasure1: json['strMeasure1'] as String?,
      strMeasure2: json['strMeasure2'] as String?,
      strMeasure3: json['strMeasure3'] as String?,
      strMeasure4: json['strMeasure4'] as String?,
      strMeasure5: json['strMeasure5'] as String?,
      strMeasure6: json['strMeasure6'] as String?,
      strMeasure7: json['strMeasure7'] as String?,
      strMeasure8: json['strMeasure8'] as String?,
      strMeasure9: json['strMeasure9'] as String?,
      strMeasure10: json['strMeasure10'] as String?,
      strMeasure11: json['strMeasure11'] as String?,
      strMeasure12: json['strMeasure12'] as String?,
      strMeasure13: json['strMeasure13'] as String?,
      strMeasure14: json['strMeasure14'] as String?,
      strMeasure15: json['strMeasure15'] as String?,
      strMeasure16: json['strMeasure16'] as String?,
      strMeasure17: json['strMeasure17'] as String?,
      strMeasure18: json['strMeasure18'] as String?,
      strMeasure19: json['strMeasure19'] as String?,
      strMeasure20: json['strMeasure20'] as String?,
      strMeasures: (json['strMeasures'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      strSource: json['strSource'] as String?,
      strImageSource: json['strImageSource'] as String?,
      dateModified: json['dateModified'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      strCreativeCommonsConfirmed:
          json['strCreativeCommonsConfirmed'] as String?,
    );

Map<String, dynamic> _$MealsToJson(Meals instance) => <String, dynamic>{
      'strIngredients': instance.strIngredients,
      'idMeal': instance.idMeal,
      'strMeal': instance.strMeal,
      'strDrinkAlternate': instance.strDrinkAlternate,
      'strCategory': instance.strCategory,
      'strArea': instance.strArea,
      'strInstructions': instance.strInstructions,
      'strMealThumb': instance.strMealThumb,
      'strTags': instance.strTags,
      'strYoutube': instance.strYoutube,
      'strIngredient1': instance.strIngredient1,
      'strIngredient2': instance.strIngredient2,
      'strIngredient3': instance.strIngredient3,
      'strIngredient4': instance.strIngredient4,
      'strIngredient5': instance.strIngredient5,
      'strIngredient6': instance.strIngredient6,
      'strIngredient7': instance.strIngredient7,
      'strIngredient8': instance.strIngredient8,
      'strIngredient9': instance.strIngredient9,
      'strIngredient10': instance.strIngredient10,
      'strIngredient11': instance.strIngredient11,
      'strIngredient12': instance.strIngredient12,
      'strIngredient13': instance.strIngredient13,
      'strIngredient14': instance.strIngredient14,
      'strIngredient15': instance.strIngredient15,
      'strIngredient16': instance.strIngredient16,
      'strIngredient17': instance.strIngredient17,
      'strIngredient18': instance.strIngredient18,
      'strIngredient19': instance.strIngredient19,
      'strIngredient20': instance.strIngredient20,
      'strMeasure1': instance.strMeasure1,
      'strMeasure2': instance.strMeasure2,
      'strMeasure3': instance.strMeasure3,
      'strMeasure4': instance.strMeasure4,
      'strMeasure5': instance.strMeasure5,
      'strMeasure6': instance.strMeasure6,
      'strMeasure7': instance.strMeasure7,
      'strMeasure8': instance.strMeasure8,
      'strMeasure9': instance.strMeasure9,
      'strMeasure10': instance.strMeasure10,
      'strMeasure11': instance.strMeasure11,
      'strMeasure12': instance.strMeasure12,
      'strMeasure13': instance.strMeasure13,
      'strMeasure14': instance.strMeasure14,
      'strMeasure15': instance.strMeasure15,
      'strMeasure16': instance.strMeasure16,
      'strMeasure17': instance.strMeasure17,
      'strMeasure18': instance.strMeasure18,
      'strMeasure19': instance.strMeasure19,
      'strMeasure20': instance.strMeasure20,
      'strSource': instance.strSource,
      'strImageSource': instance.strImageSource,
      'strCreativeCommonsConfirmed': instance.strCreativeCommonsConfirmed,
      'dateModified': instance.dateModified,
      'strMeasures': instance.strMeasures,
      'comments': instance.comments,
    };
