import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/home_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeService) : super(const HomeState()) {
    getCategories();
    getRandomMeal();
    getMealsByCategory('Beef');
  }
  final IHomeService homeService;

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

  void changeLoading() {
    emit(state.copyWith(isLoading: !(state.isLoading ?? false)));
  }
}
