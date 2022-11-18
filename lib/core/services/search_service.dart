import 'package:dio/dio.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/products/models/ingredients.dart';

abstract class ISearchService {
  ISearchService(Dio networkManager) : _manager = networkManager;
  final Dio _manager;
  Future<List<MealsIngredient>?> fetchIngredients(String key);
}

class SearchService extends ISearchService {
  SearchService(super.networkManager);
  @override
  Future<List<MealsIngredient>?> fetchIngredients(String? key) async {
    final response = await _manager.get(EndPoints.listByIngredients);
    if (response.statusCode == 200) {
      final ingredients = response.data;
      if (ingredients is Map<String, dynamic>) {
        return Ingredients.fromJson(ingredients)
            .meals
            ?.toList()
            .where((element) => element.strIngredient?.contains(key ?? '') ?? false)
            .toList();
      }
    }
    return [];
  }
}
