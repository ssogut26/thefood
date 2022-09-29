// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/category.dart';

class NetworkManager {
  NetworkManager._init();
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints().baseUrl,
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
      return [];
    }
  }

  Future<List<dynamic>> getAreas() async {
    try {
      final response = await _dio.get('list.php?a=list');
      if (response.statusCode == 200) {
        final areas = response.data['meals'];
        return areas as List;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
