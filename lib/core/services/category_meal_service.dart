import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/products/models/meals.dart';

abstract class ICategoryMealService {
  ICategoryMealService(NetworkManager networkManager) : _networkManager = networkManager;
  late final NetworkManager _networkManager;
  Future<Meal?>? getMealsByCategory(String key);
}

class CategoryMealService extends ICategoryMealService {
  CategoryMealService(super.networkManager);

  @override
  Future<Meal?>? getMealsByCategory(String key) async {
    final response = await _networkManager.service.get(
      EndPoints.filterByCategory + key,
    );
    final meals = response.data;
    if (meals is Map<String, dynamic>) {
      return Meal.fromJson(meals);
    }
    return null;
  }
}
