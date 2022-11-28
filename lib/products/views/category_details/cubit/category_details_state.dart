part of 'category_details_cubit.dart';

class CategoryDetailsState extends Equatable {
  const CategoryDetailsState({
    this.categoryMeals,
  });

  final List<Meals>? categoryMeals;

  @override
  List<Object?> get props => [categoryMeals];

  CategoryDetailsState copyWith({
    List<Meals>? categoryMeals,
  }) {
    return CategoryDetailsState(
      categoryMeals: categoryMeals ?? this.categoryMeals,
    );
  }
}
