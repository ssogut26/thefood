import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meals.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Meal with EquatableMixin {
  Meal({
    this.meals,
  });
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  @HiveField(0)
  final List<Meals>? meals;
  Map<String, dynamic> toJson() => _$MealToJson(this);

  @override
  List<Object?> get props => [meals];
}

@HiveType(typeId: 1)
@JsonSerializable()
class Meals with EquatableMixin {
  Meals({
    this.idMeal,
    this.strMeal,
    this.strDrinkAlternate,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strTags,
    this.strYoutube,
    this.strIngredient1,
    this.strIngredient2,
    this.strIngredient3,
    this.strIngredient4,
    this.strIngredient5,
    this.strIngredient6,
    this.strIngredient7,
    this.strIngredient8,
    this.strIngredient9,
    this.strIngredient10,
    this.strIngredient11,
    this.strIngredient12,
    this.strIngredient13,
    this.strIngredient14,
    this.strIngredient15,
    this.strIngredient16,
    this.strIngredient17,
    this.strIngredient18,
    this.strIngredient19,
    this.strIngredient20,
    this.strMeasure1,
    this.strMeasure2,
    this.strMeasure3,
    this.strMeasure4,
    this.strMeasure5,
    this.strMeasure6,
    this.strMeasure7,
    this.strMeasure8,
    this.strMeasure9,
    this.strMeasure10,
    this.strMeasure11,
    this.strMeasure12,
    this.strMeasure13,
    this.strMeasure14,
    this.strMeasure15,
    this.strMeasure16,
    this.strMeasure17,
    this.strMeasure18,
    this.strMeasure19,
    this.strMeasure20,
    this.strSource,
    this.strImageSource,
    this.strCreativeCommonsConfirmed,
    this.dateModified,
  });
  factory Meals.fromJson(Map<String, dynamic> json) => _$MealsFromJson(json);
  @HiveField(0)
  String? ingredients;
  @JsonKey(name: 'idMeal')
  @HiveField(1)
  String? idMeal;
  @JsonKey(name: 'strMeal')
  @HiveField(2)
  String? strMeal;
  @JsonKey(name: 'strDrinkAlternate')
  @HiveField(3)
  String? strDrinkAlternate;
  @JsonKey(name: 'strCategory')
  @HiveField(4)
  String? strCategory;
  @JsonKey(name: 'strArea')
  @HiveField(5)
  String? strArea;
  @JsonKey(name: 'strInstructions')
  @HiveField(6)
  String? strInstructions;
  @JsonKey(name: 'strMealThumb')
  @HiveField(7)
  String? strMealThumb;
  @JsonKey(name: 'strTags')
  @HiveField(8)
  String? strTags;
  @JsonKey(name: 'strYoutube')
  @HiveField(9)
  String? strYoutube;
  @JsonKey(name: 'strIngredient1')
  @HiveField(10)
  String? strIngredient1;
  @JsonKey(name: 'strIngredient2')
  @HiveField(11)
  String? strIngredient2;
  @JsonKey(name: 'strIngredient3')
  @HiveField(12)
  String? strIngredient3;
  @JsonKey(name: 'strIngredient4')
  @HiveField(13)
  String? strIngredient4;
  @JsonKey(name: 'strIngredient5')
  @HiveField(14)
  String? strIngredient5;
  @JsonKey(name: 'strIngredient6')
  @HiveField(15)
  String? strIngredient6;
  @JsonKey(name: 'strIngredient7')
  @HiveField(16)
  String? strIngredient7;
  @JsonKey(name: 'strIngredient8')
  @HiveField(17)
  String? strIngredient8;
  @JsonKey(name: 'strIngredient9')
  @HiveField(18)
  String? strIngredient9;
  @JsonKey(name: 'strIngredient10')
  @HiveField(19)
  String? strIngredient10;
  @JsonKey(name: 'strIngredient11')
  @HiveField(20)
  String? strIngredient11;
  @JsonKey(name: 'strIngredient12')
  @HiveField(21)
  String? strIngredient12;
  @JsonKey(name: 'strIngredient13')
  @HiveField(22)
  String? strIngredient13;
  @JsonKey(name: 'strIngredient14')
  @HiveField(23)
  String? strIngredient14;
  @JsonKey(name: 'strIngredient15')
  @HiveField(24)
  String? strIngredient15;
  @JsonKey(name: 'strIngredient16')
  @HiveField(25)
  String? strIngredient16;
  @JsonKey(name: 'strIngredient17')
  @HiveField(26)
  String? strIngredient17;
  @JsonKey(name: 'strIngredient18')
  @HiveField(27)
  String? strIngredient18;
  @JsonKey(name: 'strIngredient19')
  @HiveField(28)
  String? strIngredient19;
  @JsonKey(name: 'strIngredient20')
  @HiveField(29)
  String? strIngredient20;
  @JsonKey(name: 'strMeasure1')
  @HiveField(30)
  String? strMeasure1;
  @JsonKey(name: 'strMeasure2')
  @HiveField(31)
  String? strMeasure2;
  @JsonKey(name: 'strMeasure3')
  @HiveField(32)
  String? strMeasure3;
  @JsonKey(name: 'strMeasure4')
  @HiveField(33)
  String? strMeasure4;
  @JsonKey(name: 'strMeasure5')
  @HiveField(34)
  String? strMeasure5;
  @JsonKey(name: 'strMeasure6')
  @HiveField(35)
  String? strMeasure6;
  @JsonKey(name: 'strMeasure7')
  @HiveField(36)
  String? strMeasure7;
  @JsonKey(name: 'strMeasure8')
  @HiveField(37)
  String? strMeasure8;
  @JsonKey(name: 'strMeasure9')
  @HiveField(38)
  String? strMeasure9;
  @JsonKey(name: 'strMeasure10')
  @HiveField(39)
  String? strMeasure10;
  @JsonKey(name: 'strMeasure11')
  @HiveField(40)
  String? strMeasure11;
  @JsonKey(name: 'strMeasure12')
  @HiveField(41)
  String? strMeasure12;
  @JsonKey(name: 'strMeasure13')
  @HiveField(42)
  String? strMeasure13;
  @JsonKey(name: 'strMeasure14')
  @HiveField(43)
  String? strMeasure14;
  @JsonKey(name: 'strMeasure15')
  @HiveField(44)
  String? strMeasure15;
  @JsonKey(name: 'strMeasure16')
  @HiveField(45)
  String? strMeasure16;
  @JsonKey(name: 'strMeasure17')
  @HiveField(46)
  String? strMeasure17;
  @JsonKey(name: 'strMeasure18')
  @HiveField(47)
  String? strMeasure18;
  @JsonKey(name: 'strMeasure19')
  @HiveField(48)
  String? strMeasure19;
  @JsonKey(name: 'strMeasure20')
  @HiveField(49)
  String? strMeasure20;
  @JsonKey(name: 'strSource')
  @HiveField(50)
  String? strSource;
  @JsonKey(name: 'strImageSource')
  @HiveField(51)
  String? strImageSource;
  @JsonKey(name: 'strCreativeCommonsConfirmed')
  @HiveField(52)
  String? strCreativeCommonsConfirmed;
  @JsonKey(name: 'dateModified')
  @HiveField(53)
  String? dateModified;

  Map<String, dynamic> toJson() => _$MealsToJson(this);

  @override
  List<Object?> get props => [
        idMeal,
        strMeal,
        strDrinkAlternate,
        strCategory,
        strArea,
        strInstructions,
        strMealThumb,
        strTags,
        strYoutube,
        strIngredient1,
        strIngredient2,
        strIngredient3,
        strIngredient4,
        strIngredient5,
        strIngredient6,
        strIngredient7,
        strIngredient8,
        strIngredient9,
        strIngredient10,
        strIngredient11,
        strIngredient12,
        strIngredient13,
        strIngredient14,
        strIngredient15,
        strIngredient16,
        strIngredient17,
        strIngredient18,
        strIngredient19,
        strIngredient20,
        strMeasure1,
        strMeasure2,
        strMeasure3,
        strMeasure4,
        strMeasure5,
        strMeasure6,
        strMeasure7,
        strMeasure8,
        strMeasure9,
        strMeasure10,
        strMeasure11,
        strMeasure12,
        strMeasure13,
        strMeasure14,
        strMeasure15,
        strMeasure16,
        strMeasure17,
        strMeasure18,
        strMeasure19,
        strMeasure20,
        strSource,
        strImageSource,
        strCreativeCommonsConfirmed,
        dateModified
      ];

  Meals copyWith({
    String? idMeal,
    String? strMeal,
    String? strDrinkAlternate,
    String? strCategory,
    String? strArea,
    String? strInstructions,
    String? strMealThumb,
    String? strTags,
    String? strYoutube,
    String? strIngredient1,
    String? strIngredient2,
    String? strIngredient3,
    String? strIngredient4,
    String? strIngredient5,
    String? strIngredient6,
    String? strIngredient7,
    String? strIngredient8,
    String? strIngredient9,
    String? strIngredient10,
    String? strIngredient11,
    String? strIngredient12,
    String? strIngredient13,
    String? strIngredient14,
    String? strIngredient15,
    String? strIngredient16,
    String? strIngredient17,
    String? strIngredient18,
    String? strIngredient19,
    String? strIngredient20,
    String? strMeasure1,
    String? strMeasure2,
    String? strMeasure3,
    String? strMeasure4,
    String? strMeasure5,
    String? strMeasure6,
    String? strMeasure7,
    String? strMeasure8,
    String? strMeasure9,
    String? strMeasure10,
    String? strMeasure11,
    String? strMeasure12,
    String? strMeasure13,
    String? strMeasure14,
    String? strMeasure15,
    String? strMeasure16,
    String? strMeasure17,
    String? strMeasure18,
    String? strMeasure19,
    String? strMeasure20,
    String? strSource,
    String? strImageSource,
    String? strCreativeCommonsConfirmed,
    String? dateModified,
  }) {
    return Meals(
      idMeal: idMeal ?? this.idMeal,
      strMeal: strMeal ?? this.strMeal,
      strDrinkAlternate: strDrinkAlternate ?? this.strDrinkAlternate,
      strCategory: strCategory ?? this.strCategory,
      strArea: strArea ?? this.strArea,
      strInstructions: strInstructions ?? this.strInstructions,
      strMealThumb: strMealThumb ?? this.strMealThumb,
      strTags: strTags ?? this.strTags,
      strYoutube: strYoutube ?? this.strYoutube,
      strIngredient1: strIngredient1 ?? this.strIngredient1,
      strIngredient2: strIngredient2 ?? this.strIngredient2,
      strIngredient3: strIngredient3 ?? this.strIngredient3,
      strIngredient4: strIngredient4 ?? this.strIngredient4,
      strIngredient5: strIngredient5 ?? this.strIngredient5,
      strIngredient6: strIngredient6 ?? this.strIngredient6,
      strIngredient7: strIngredient7 ?? this.strIngredient7,
      strIngredient8: strIngredient8 ?? this.strIngredient8,
      strIngredient9: strIngredient9 ?? this.strIngredient9,
      strIngredient10: strIngredient10 ?? this.strIngredient10,
      strIngredient11: strIngredient11 ?? this.strIngredient11,
      strIngredient12: strIngredient12 ?? this.strIngredient12,
      strIngredient13: strIngredient13 ?? this.strIngredient13,
      strIngredient14: strIngredient14 ?? this.strIngredient14,
      strIngredient15: strIngredient15 ?? this.strIngredient15,
      strIngredient16: strIngredient16 ?? this.strIngredient16,
      strIngredient17: strIngredient17 ?? this.strIngredient17,
      strIngredient18: strIngredient18 ?? this.strIngredient18,
      strIngredient19: strIngredient19 ?? this.strIngredient19,
      strIngredient20: strIngredient20 ?? this.strIngredient20,
      strMeasure1: strMeasure1 ?? this.strMeasure1,
      strMeasure2: strMeasure2 ?? this.strMeasure2,
      strMeasure3: strMeasure3 ?? this.strMeasure3,
      strMeasure4: strMeasure4 ?? this.strMeasure4,
      strMeasure5: strMeasure5 ?? this.strMeasure5,
      strMeasure6: strMeasure6 ?? this.strMeasure6,
      strMeasure7: strMeasure7 ?? this.strMeasure7,
      strMeasure8: strMeasure8 ?? this.strMeasure8,
      strMeasure9: strMeasure9 ?? this.strMeasure9,
      strMeasure10: strMeasure10 ?? this.strMeasure10,
      strMeasure11: strMeasure11 ?? this.strMeasure11,
      strMeasure12: strMeasure12 ?? this.strMeasure12,
      strMeasure13: strMeasure13 ?? this.strMeasure13,
      strMeasure14: strMeasure14 ?? this.strMeasure14,
      strMeasure15: strMeasure15 ?? this.strMeasure15,
      strMeasure16: strMeasure16 ?? this.strMeasure16,
      strMeasure17: strMeasure17 ?? this.strMeasure17,
      strMeasure18: strMeasure18 ?? this.strMeasure18,
      strMeasure19: strMeasure19 ?? this.strMeasure19,
      strMeasure20: strMeasure20 ?? this.strMeasure20,
      strSource: strSource ?? this.strSource,
      strImageSource: strImageSource ?? this.strImageSource,
      strCreativeCommonsConfirmed:
          strCreativeCommonsConfirmed ?? this.strCreativeCommonsConfirmed,
      dateModified: dateModified ?? this.dateModified,
    );
  }
}
