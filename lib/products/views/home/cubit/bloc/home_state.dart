part of 'home_cubit.dart';

class HomeState extends Equatable {
  HomeState({
    this.mealCategory,
    this.categoryMealItems,
    this.randomMeal,
    this.mealsByCategory,
    this.randomMealItems,
    this.categoryName,
    this.isCompleted = false,
    this.selectedIndex = 0,
  });

  List<MealCategory>? mealCategory;
  Meal? categoryMealItems;
  Meal? randomMealItems;
  final bool? isCompleted;
  final Meal? mealsByCategory;
  final Meal? randomMeal;
  final String? categoryName;
  int selectedIndex;

  @override
  List<Object?> get props => [
        mealCategory,
        categoryMealItems,
        randomMealItems,
        mealsByCategory,
        randomMeal,
        categoryName,
        isCompleted,
        selectedIndex,
      ];

  HomeState copyWith({
    List<MealCategory>? mealCategory,
    Meal? mealsByCategory,
    Meal? randomMealItems,
    Meal? categoryMealItems,
    Meal? randomMeal,
    String? categoryName,
    bool? isCompleted,
    int? selectedIndex,
  }) {
    return HomeState(
      mealCategory: mealCategory ?? this.mealCategory,
      categoryMealItems: categoryMealItems ?? this.categoryMealItems,
      isCompleted: isCompleted ?? this.isCompleted,
      randomMealItems: randomMealItems ?? this.randomMealItems,
      mealsByCategory: mealsByCategory ?? this.mealsByCategory,
      randomMeal: randomMeal ?? this.randomMeal,
      categoryName: categoryName ?? this.categoryName,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
