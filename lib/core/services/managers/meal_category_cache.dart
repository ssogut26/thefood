part of 'cache_manager.dart';

class MealCategoryCacheManager extends ICacheManager<MealCategory> {
  MealCategoryCacheManager(super.key);

  @override
  Future<void> addItems(List<MealCategory> items) async {
    await _box?.addAll(items);
  }

  @override
  Future<void> putItems(List<MealCategory> items) async {
    await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.idCategory, e))));
  }

  @override
  MealCategory? getItem(String key) {
    return _box?.get(key);
  }

  @override
  Future<void> putItem(String key, MealCategory item) async {
    await _box?.put(key, item);
  }

  @override
  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  @override
  List<MealCategory>? getValues() {
    return _box?.values.toList();
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CategoriesAdapter());
      Hive.registerAdapter(MealCategoryAdapter());
    }
  }
}
