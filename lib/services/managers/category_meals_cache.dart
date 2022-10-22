part of 'cache_manager.dart';

class CategoryMealsCacheManager extends ICacheManager<Meal> {
  CategoryMealsCacheManager(super.key);

  @override
  Future<void> addItems(List<Meal> items) async {
    await _box?.addAll(items);
  }

  @override
  Future<void> putItems(List<Meal> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.meals, e))));
  }

  @override
  Meal? getItem(String key) {
    return _box?.get(key);
  }

  @override
  Future<void> putItem(String key, Meal item) async {
    await _box?.put(key, item);
  }

  @override
  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  @override
  List<Meal>? getValues() {
    return _box?.values.toList();
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MealAdapter());
      Hive.registerAdapter(MealsAdapter());
    }
  }
}
