part of 'cache_manager.dart';

class FavoriteMealDetailCacheManager extends ICacheManager<Meal> {
  FavoriteMealDetailCacheManager(super.key);

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

  Future<void> initLazyBox() async {
    LazyBox<Meal>? box;
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openLazyBox(key);
    }
  }

  @override
  void registerAdapters() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MealsAdapter());
      Hive.registerAdapter(MealAdapter());
    }
  }
}
