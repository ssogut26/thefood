import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meals.g.dart';

@JsonSerializable()
class Meal with EquatableMixin {
  Meal({
    this.meals,
  });
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  final List<Meals>? meals;
  Map<String, dynamic> toJson() => _$MealToJson(this);

  @override
  List<Object?> get props => [meals];
}

@JsonSerializable()
class Meals with EquatableMixin {
  factory Meals.fromJson(Map<String, dynamic> json) => _$MealsFromJson(json);

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
  String? ingredients;
  @JsonKey(name: 'idMeal')
  String? idMeal;
  @JsonKey(name: 'strMeal')
  String? strMeal;
  @JsonKey(name: 'strDrinkAlternate')
  String? strDrinkAlternate;
  @JsonKey(name: 'strCategory')
  String? strCategory;
  @JsonKey(name: 'strArea')
  String? strArea;
  @JsonKey(name: 'strInstructions')
  String? strInstructions;
  @JsonKey(name: 'strMealThumb')
  String? strMealThumb;
  @JsonKey(name: 'strTags')
  String? strTags;
  @JsonKey(name: 'strYoutube')
  String? strYoutube;
  @JsonKey(name: 'strIngredient1')
  String? strIngredient1;
  @JsonKey(name: 'strIngredient2')
  String? strIngredient2;
  @JsonKey(name: 'strIngredient3')
  String? strIngredient3;
  @JsonKey(name: 'strIngredient4')
  String? strIngredient4;
  @JsonKey(name: 'strIngredient5')
  String? strIngredient5;
  @JsonKey(name: 'strIngredient6')
  String? strIngredient6;
  @JsonKey(name: 'strIngredient7')
  String? strIngredient7;
  @JsonKey(name: 'strIngredient8')
  String? strIngredient8;
  @JsonKey(name: 'strIngredient9')
  String? strIngredient9;
  @JsonKey(name: 'strIngredient10')
  String? strIngredient10;
  @JsonKey(name: 'strIngredient11')
  String? strIngredient11;
  @JsonKey(name: 'strIngredient12')
  String? strIngredient12;
  @JsonKey(name: 'strIngredient13')
  String? strIngredient13;
  @JsonKey(name: 'strIngredient14')
  String? strIngredient14;
  @JsonKey(name: 'strIngredient15')
  String? strIngredient15;
  @JsonKey(name: 'strIngredient16')
  String? strIngredient16;
  @JsonKey(name: 'strIngredient17')
  String? strIngredient17;
  @JsonKey(name: 'strIngredient18')
  String? strIngredient18;
  @JsonKey(name: 'strIngredient19')
  String? strIngredient19;
  @JsonKey(name: 'strIngredient20')
  String? strIngredient20;
  @JsonKey(name: 'strMeasure1')
  String? strMeasure1;
  @JsonKey(name: 'strMeasure2')
  String? strMeasure2;
  @JsonKey(name: 'strMeasure3')
  String? strMeasure3;
  @JsonKey(name: 'strMeasure4')
  String? strMeasure4;
  @JsonKey(name: 'strMeasure5')
  String? strMeasure5;
  @JsonKey(name: 'strMeasure6')
  String? strMeasure6;
  @JsonKey(name: 'strMeasure7')
  String? strMeasure7;
  @JsonKey(name: 'strMeasure8')
  String? strMeasure8;
  @JsonKey(name: 'strMeasure9')
  String? strMeasure9;
  @JsonKey(name: 'strMeasure10')
  String? strMeasure10;
  @JsonKey(name: 'strMeasure11')
  String? strMeasure11;
  @JsonKey(name: 'strMeasure12')
  String? strMeasure12;
  @JsonKey(name: 'strMeasure13')
  String? strMeasure13;
  @JsonKey(name: 'strMeasure14')
  String? strMeasure14;
  @JsonKey(name: 'strMeasure15')
  String? strMeasure15;
  @JsonKey(name: 'strMeasure16')
  String? strMeasure16;
  @JsonKey(name: 'strMeasure17')
  String? strMeasure17;
  @JsonKey(name: 'strMeasure18')
  String? strMeasure18;
  @JsonKey(name: 'strMeasure19')
  String? strMeasure19;
  @JsonKey(name: 'strMeasure20')
  String? strMeasure20;
  @JsonKey(name: 'strSource')
  String? strSource;
  @JsonKey(name: 'strImageSource')
  String? strImageSource;
  @JsonKey(name: 'strCreativeCommonsConfirmed')
  String? strCreativeCommonsConfirmed;
  @JsonKey(name: 'dateModified')
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
