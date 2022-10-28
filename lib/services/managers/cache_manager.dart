import 'package:hive_flutter/hive_flutter.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';

part 'category_meals_cache.dart';
part 'favorite_meal_detail_cache.dart';
part 'meal_category_cache.dart';
part 'random_meal_cache_manager.dart';

abstract class ICacheManager<T> {
  ICacheManager(this.key);
  final String key;
  Box<T>? _box;
  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  void registerAdapters();

  Future<void> clearAll() async {
    await _box?.clear();
  }

  Future<void> addItems(List<T> items);
  Future<void> putItems(List<T> items);

  T? getItem(String key);
  List<T>? getValues();

  Future<void> putItem(String key, T item);
  Future<void> removeItem(String key);
}

abstract class ICacheUserData<User> {
  ICacheUserData(this.key);
  final String key;
  Box<User>? _box;
  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  void registerAdapters();

  Future<void> clearAll() async {
    await _box?.clear();
  }

  Future<void> addItems(List<User> user);
  Future<void> putItems(List<User> user);

  User? getItem(String key);
  List<User>? getValues();

  Future<void> putItem(String key, User user);
  Future<void> removeItem(String key);
}
