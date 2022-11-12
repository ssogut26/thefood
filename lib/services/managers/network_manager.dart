// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/categories.dart';
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

  Future<Meal?> getMealsByCategory(String key) async {
    final response = await _dio.get(
      EndPoints.filterByCategory + key,
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

  // get firestore data
  // Future<List<FieldValue>?> getFirestoreData() async {
  //   final ref = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid);

  //   final docSnap = await ref.get();
  //   if (docSnap.exists) {
  //     return docSnap.data()?['recipes'] as List<FieldValue>;
  //   }
  //   return null;
  // }
}
