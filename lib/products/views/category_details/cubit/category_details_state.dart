part of 'category_details_cubit.dart';

class CategoryDetailsState extends Equatable {
  const CategoryDetailsState({
    this.categoryMeals,
  });

  final Meal? categoryMeals;

  @override
  List<Object?> get props => [categoryMeals];

  CategoryDetailsState copyWith({
    Meal? categoryMeals,
  }) {
    return CategoryDetailsState(
      categoryMeals: categoryMeals ?? this.categoryMeals,
    );
  }
}
