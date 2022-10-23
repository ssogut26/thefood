import 'package:flutter/foundation.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/network_manager.dart';

abstract class IHomeService {
  IHomeService(NetworkManager networkManager) : _networkManager = networkManager;
  late final NetworkManager _networkManager;
  Future<List<MealCategory>?> getCategories();
  Future<Meal?> getMealsByCategory(String name);
  Future<Meal?> getRandomMeal();
}

class HomeService extends IHomeService {
  HomeService(super.networkManager);

  @override
  Future<List<MealCategory>?> getCategories() async {
    try {
      final response = await _networkManager.service.get(EndPoints.categories);
      final categories =
          Categories.fromJson(response.data as Map<String, dynamic>).categories;
      return categories;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
  Future<Meal?> getMealsByCategory(String name) async {
    final response = await _networkManager.service.get(
      EndPoints.filterByCategory + name,
    );
    if (response.data is Map<String, dynamic>) {
      return Meal.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<Meal?> getRandomMeal() async {
    final response = await _networkManager.service.get(EndPoints.randomMeal);
    if (response.statusCode == 200) {
      final meals = response.data;
      if (meals is Map<String, dynamic>) {
        return Meal.fromJson(meals);
      }
    }
    return null;
  }
}
