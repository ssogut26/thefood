// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/area.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
import 'package:thefood/models/meals.dart';

class NetworkManager {
  NetworkManager._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints().baseUrl,
      ),
    );
  }
  late final Dio _dio;
  static final NetworkManager instance = NetworkManager._();
  Dio get service => _dio;

  Future<List<MealCategory>?> getCategories() async {
    try {
      final response = await _dio.get(EndPoints().categories);
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

  Future<Area?> getAreas() async {
    final response = await _dio.get(EndPoints().listByArea);
    if (response.statusCode == 200) {
      final area = response.data;
      if (area is Map<String, dynamic>) {
        return Area.fromJson(area);
      }
    }
    return null;
  }

  Future<Ingredients?> getIngredients() async {
    final response = await _dio.get(EndPoints().listByIngredients);
    if (response.statusCode == 200) {
      final ingredients = response.data;
      if (ingredients is Map<String, dynamic>) {
        return Ingredients.fromJson(ingredients);
      }
    }
    return null;
  }

  // Future<Meal?> getMealsByArea(String name) async {
  //   final response = await _dio.get(
  //     EndPoints().filterByArea + name,
  //   );
  //   print(response.toString());
  //   if (response.statusCode == 200) {
  //     final meals = response.data;
  //     if (meals is Map<String, dynamic>) {
  //       return Meal.fromJson(meals);
  //     }
  //   }
  //   return null;
  // }

  Future<Meal?> getMeals(String name) async {
    final response = await _dio.get(
      EndPoints().filterByArea + name,
    );
    final response2 = await _dio.get(
      EndPoints().filterByCategory + name,
    );
    final response3 = await _dio.get(
      EndPoints().filterByMainIngredients + name,
    );
    final rp1meals = response.data;
    final rp2meals = response2.data;
    final rp3meals = response3.data;
    if (rp2meals is Map<String, dynamic> && rp2meals.entries.first.value == null) {
      if (rp1meals is Map<String, dynamic>) {
        return Meal.fromJson(rp1meals);
      }
      return Meal.fromJson(rp1meals as Map<String, dynamic>);
    } else if (rp2meals is Map<String, dynamic>) {
      return Meal.fromJson(rp2meals);
    } else {
      return Meal.fromJson(rp3meals as Map<String, dynamic>);
    }
  }
}
