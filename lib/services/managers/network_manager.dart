// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/area.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
import 'package:thefood/models/meals.dart';

class NetworkManager {
  NetworkManager._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
      ),
    );
  }
  late final Dio _dio;
  static final NetworkManager instance = NetworkManager._();
  Dio get service => _dio;

  Future<List<MealCategory>?> getCategories() async {
    try {
      final response = await _dio.get(EndPoints.categories);
      final categories =
          Categories.fromJson(response.data as Map<String, dynamic>).categories;
      return categories;
    } on DioError catch (e) {
      SnackBar(
        content: Text(e.response.toString()),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
    return null;
  }

  Future<Area?> getAreas() async {
    final response = await _dio.get(EndPoints.listByArea);
    if (response.statusCode == 200) {
      final area = response.data;
      if (area is Map<String, dynamic>) {
        return Area.fromJson(area);
      }
    }
    return null;
  }

  Future<Ingredients?> getIngredients() async {
    final response = await _dio.get(EndPoints.listByIngredients);
    if (response.statusCode == 200) {
      final ingredients = response.data;
      if (ingredients is Map<String, dynamic>) {
        return Ingredients.fromJson(ingredients);
      }
    }
    return null;
  }

  Future<Meal?> getMealsByCategory(String name) async {
    final response = await _dio.get(
      EndPoints.filterByCategory + name,
    );
    if (response.data is Map<String, dynamic>) {
      return Meal.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  Future<Meal?> getRandomMeal() async {
    final response = await _dio.get(EndPoints.randomMeal);
    if (response.statusCode == 200) {
      final meals = response.data;
      if (meals is Map<String, dynamic>) {
        return Meal.fromJson(meals);
      }
    }
    return null;
  }

  Future<Meal?> getMeal(int id) async {
    final response = await _dio.get('${EndPoints.getMealDetail}$id');
    if (response.statusCode == 200) {
      final meals = response.data;
      if (meals is Map<String, dynamic>) {
        return Meal.fromJson(meals);
      }
    }
    return null;
  }
}
