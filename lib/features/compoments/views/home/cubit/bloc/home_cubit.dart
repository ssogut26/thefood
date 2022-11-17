import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/services/home_service.dart';
import 'package:thefood/core/services/managers/cache_manager.dart';
import 'package:thefood/features/compoments/models/categories.dart';
import 'package:thefood/features/compoments/models/meals.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeService) : super(HomeState()) {
    getCategories();
    changeLoading();
    getRandomMeal();
    getMealsByCategory('Beef');
    fetchCategoryData();
    fetchCategoryMealData();
    fetchRandomMealData();
  }
  final IHomeService homeService;
  final ICacheManager<MealCategory> categoryCacheManager =
      MealCategoryCacheManager('mealCategory');
  final ICacheManager<Meal> mealCacheManager = CategoryMealsCacheManager('categoryMeal');
  final ICacheManager<Meal> randomMealCacheManager = RandomMealCacheManager('randomMeal');

  Future<void> getCategories() async {
    final mealCategory = await homeService.getCategories();
    emit(state.copyWith(mealCategory: mealCategory));
  }

  Future<Meal> getMealsByCategory(String name) async {
    final mealsByCategory = await homeService.getMealsByCategory(name);
    emit(state.copyWith(mealsByCategory: mealsByCategory));
    return mealsByCategory!;
  }

  Future<void> getRandomMeal() async {
    final randomMeal = await homeService.getRandomMeal();
    emit(state.copyWith(randomMeal: randomMeal));
  }

  Future<void> fetchCategoryData() async {
    await categoryCacheManager.init();
    if (categoryCacheManager.getValues()?.isNotEmpty ?? false) {
      state.mealCategory = categoryCacheManager.getValues();
    } else {
      state.mealCategory = await homeService.getCategories();
    }
    emit(state.copyWith(mealCategory: state.mealCategory));
  }

  Future<void> fetchCategoryMealData() async {
    await mealCacheManager.init();
    if (mealCacheManager.getItem('Beef')?.meals?.isNotEmpty ?? false) {
      state.categoryMealItems = mealCacheManager.getItem('Beef');
    } else {
      state.categoryMealItems = await homeService.getMealsByCategory('Beef');

      emit(state.copyWith(categoryMealItems: state.categoryMealItems));
    }
  }

  Future<void> fetchRandomMealData() async {
    await randomMealCacheManager.init();
    if (randomMealCacheManager.getItem(EndPoints.randomMeal)?.meals?.isNotEmpty ??
        false) {
      state.randomMealItems = randomMealCacheManager.getItem(EndPoints.randomMeal);
    } else {
      state.randomMealItems = await homeService.getRandomMeal();
    }
    emit(state.copyWith(randomMealItems: state.randomMealItems));
  }

  void changeLoading() {
    emit(state.copyWith(isLoading: !(state.isLoading ?? false)));
  }

  void changeSelectedIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
