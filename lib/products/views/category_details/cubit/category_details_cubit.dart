import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/core/services/category_meal_service.dart';
import 'package:thefood/products/models/meals.dart';

part 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit(
    this.categoryMealService,
  ) : super(
          const CategoryDetailsState(),
        ) {
    getMealsByCategory(key);
  }
  final ICategoryMealService categoryMealService;
  final String key = '';

  Future<Meal?> getMealsByCategory(String key) async {
    final categoryMeals = await categoryMealService.getMealsByCategory(key);
    emit(
      state.copyWith(
        categoryMeals: categoryMeals,
      ),
    );

    return categoryMeals;
  }
}
