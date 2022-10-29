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
      if (response.statusCode == 200) {
        final categories = response.data;
        if (categories is Map<String, dynamic>) {
          return Categories.fromJson(categories).categories;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
    return null;
  }

  @override
  Future<Meal?> getMealsByCategory(String name) async {
    final response = await _networkManager.service.get(
      EndPoints.filterByCategory + name,
    );
    if (response.statusCode == 200) {
      final meal = response.data;
      if (meal is Map<String, dynamic>) {
        return Meal.fromJson(meal);
      }
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
