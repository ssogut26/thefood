import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/products/models/meals.dart';

abstract class ICategoryMealService {
  ICategoryMealService(NetworkManager networkManager) : _networkManager = networkManager;
  late final NetworkManager _networkManager;
  Future<List<Meals>?>? getMealsByCategory(String key);
}

class CategoryMealService extends ICategoryMealService {
  CategoryMealService(super.networkManager);

  @override
  Future<List<Meals>?>? getMealsByCategory(String key) async {
    final response = await _networkManager.service.get<Map<String, dynamic>>(
      EndPoints.filterByCategory + key,
    );
    final response2 =
        FirebaseFirestore.instance.collection('recipes').orderBy('strCategory').get();
    final result = await response2.then(
      (value) => value.docs
          .map((e) => Meals.fromJson(e.data()))
          .where((element) => element.strCategory?.contains(key) ?? false)
          .toList(),
    );
    final meals = response.data;
    if (meals is Map<String, dynamic>) {
      final results = [Meal.fromJson(meals).meals ?? <Meals>[], result];
      return results.expand((element) => element).toList();
    }
    return null;
  }
}
