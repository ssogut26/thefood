import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/category.dart';

class NetworkManager {
  NetworkManager._init();
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  final baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.themealdb.com/api/json/v1/1/',
    ),
  );

  Future<List<MealCategory>?> getCategories() async {
    try {
      final response = await _dio.get('categories.php');
      final categories =
          Categories.fromJson(response.data as Map<String, dynamic>).categories;
      return categories;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
