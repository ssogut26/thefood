part of 'home_cubit.dart';

class HomeState extends Equatable {
  HomeState({
    this.mealCategory,
    this.isLoading,
    this.categoryMealItems,
    this.randomMeal,
    this.mealsByCategory,
    this.randomMealItems,
    this.categoryName,
    this.selectedIndex = 0,
  });

  List<MealCategory>? mealCategory;
  Meal? categoryMealItems;
  Meal? randomMealItems;
  final bool? isLoading;
  final Meal? mealsByCategory;
  final Meal? randomMeal;
  final String? categoryName;
  int selectedIndex;

  @override
  List<Object?> get props => [
        mealCategory,
        isLoading,
        categoryMealItems,
        randomMealItems,
        mealsByCategory,
        randomMeal,
        categoryName,
        selectedIndex,
      ];

  HomeState copyWith({
    List<MealCategory>? mealCategory,
    bool? isLoading,
    Meal? mealsByCategory,
    Meal? randomMealItems,
    Meal? categoryMealItems,
    Meal? randomMeal,
    String? categoryName,
    int? selectedIndex,
  }) {
    return HomeState(
      mealCategory: mealCategory ?? this.mealCategory,
      isLoading: isLoading ?? this.isLoading,
      categoryMealItems: categoryMealItems ?? this.categoryMealItems,
      randomMealItems: randomMealItems ?? this.randomMealItems,
      mealsByCategory: mealsByCategory ?? this.mealsByCategory,
      randomMeal: randomMeal ?? this.randomMeal,
      categoryName: categoryName ?? this.categoryName,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
