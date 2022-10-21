import 'package:hive_flutter/hive_flutter.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';

part of 'details_view.dart';

class DetailModels {
  final favoriteMealBox = Hive.box<Meal>(ProjectTexts.favoriteBoxName);
  final meals = Meals();
  Future<void Function()?> onFavoritePress(
    int id,
    String name,
    String image,
    List<String?> ingList,
    String instructions,
    String youtube,
    String category,
    String source,
    List<String?> measures,
    String area,
  ) async {
    await favoriteMealBox.put(
      '$id',
      Meal(
        meals: [
          meals.copyWith(
            idMeal: id.toString(),
            strMeal: name,
            strMealThumb: image,
            strIngredient1: ingList[0],
            strIngredient2: ingList[1],
            strIngredient3: ingList[2],
            strIngredient4: ingList[3],
            strIngredient5: ingList[4],
            strIngredient6: ingList[5],
            strIngredient7: ingList[6],
            strIngredient8: ingList[7],
            strIngredient9: ingList[8],
            strIngredient10: ingList[9],
            strIngredient11: ingList[10],
            strIngredient12: ingList[11],
            strIngredient13: ingList[12],
            strIngredient14: ingList[13],
            strIngredient15: ingList[14],
            strIngredient16: ingList[15],
            strIngredient17: ingList[16],
            strIngredient18: ingList[17],
            strIngredient19: ingList[18],
            strIngredient20: ingList[19],
            strInstructions: instructions,
            strYoutube: youtube,
            strCategory: category,
            strSource: source,
            strMeasure1: measures[0],
            strMeasure2: measures[1],
            strMeasure3: measures[2],
            strMeasure4: measures[3],
            strMeasure5: measures[4],
            strMeasure6: measures[5],
            strMeasure7: measures[6],
            strMeasure8: measures[7],
            strMeasure9: measures[8],
            strMeasure10: measures[9],
            strMeasure11: measures[10],
            strMeasure12: measures[11],
            strMeasure13: measures[12],
            strMeasure14: measures[13],
            strMeasure15: measures[14],
            strMeasure16: measures[15],
            strMeasure17: measures[16],
            strMeasure18: measures[17],
            strMeasure19: measures[18],
            strMeasure20: measures[19],
            strArea: area,
          ),
        ],
      ),
    );
    return null;
  }
}
