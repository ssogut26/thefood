part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.mealCategory,
    this.isLoading,
    this.mealsByCategory,
    this.randomMeal,
    this.categoryName,
  });

  final List<MealCategory>? mealCategory;
  final bool? isLoading;
  final Meal? mealsByCategory;
  final Meal? randomMeal;
  final String? categoryName;

  @override
  List<Object?> get props => [
        mealCategory,
        isLoading,
        mealsByCategory,
        randomMeal,
        categoryName,
      ];

  HomeState copyWith({
    List<MealCategory>? mealCategory,
    bool? isLoading,
    Meal? mealsByCategory,
    Meal? randomMeal,
    String? categoryName,
  }) {
    return HomeState(
      mealCategory: mealCategory ?? this.mealCategory,
      isLoading: isLoading ?? this.isLoading,
      mealsByCategory: mealsByCategory ?? this.mealsByCategory,
      randomMeal: randomMeal ?? this.randomMeal,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
