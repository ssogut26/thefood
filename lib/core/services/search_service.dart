import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/products/models/ingredients.dart';
import 'package:thefood/products/models/meals.dart';

abstract class ISearchService {
  ISearchService(Dio networkManager) : _manager = networkManager;
  final Dio _manager;
  Future<List<MealsIngredient>?> fetchIngredients(String key);
  Future<List<Meals>> searchMeals(String key);
}

class SearchService extends ISearchService {
  SearchService(super.networkManager);
  @override
  Future<List<MealsIngredient>?> fetchIngredients(String? key) async {
    final response =
        await _manager.get<Map<String, dynamic>>(EndPoints.listByIngredients);
    if (response.statusCode == 200) {
      final ingredients = response.data;
      if (ingredients is Map<String, dynamic>) {
        return Ingredients.fromJson(ingredients)
            .meals
            ?.toList()
            .where(
              (element) =>
                  (element.strIngredient?.contains(key ?? '') ?? false) &&
                  (element.strIngredient?.startsWith(key ?? '') ?? false),
            )
            .toList();
      }
    }
    return [];
  }

  @override
  Future<List<Meals>> searchMeals(String? key) async {
    if (key != null) {
      final response =
          await _manager.get<Map<String, dynamic>>(EndPoints.searchByName + key);
      final response2 =
          FirebaseFirestore.instance.collection('recipes').orderBy('strMeal').get();
      final result = await response2
          .then((value) => value.docs.map((e) => Meals.fromJson(e.data())).toList());
      if (response.statusCode == 200) {
        final meals = response.data;
        if (meals is Map<String, dynamic>) {
          final results = [Meal.fromJson(meals).meals ?? <Meals>[], result];
          return results.expand((element) => element).toList();
        }
      }
    }

    return [];
  }
}
