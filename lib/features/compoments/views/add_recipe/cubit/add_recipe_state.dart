part of 'add_recipe_cubit.dart';

class AddRecipeState extends Equatable {
  AddRecipeState({
    this.ingredientList,
    this.measureList,
    this.widgetList = const [],
    this.recipeCategory,
    this.index = 0,
    this.recipeArea,
    this.idMeal,
  });

  List<String?>? ingredientList;
  List<String?>? measureList;
  List<Widget> widgetList = [];
  late int? idMeal;
  final int index;
  String? recipeCategory;
  String? recipeArea;

  @override
  List<Object?> get props =>
      [ingredientList, measureList, widgetList, idMeal, recipeCategory, recipeArea];

  AddRecipeState copyWith({
    List<String?>? ingredientList,
    List<String?>? measureList,
    List<Widget>? widgetList,
    int? idMeal,
    int? index,
    String? recipeCategory,
    String? recipeArea,
  }) {
    return AddRecipeState(
      ingredientList: ingredientList ?? this.ingredientList,
      measureList: measureList ?? this.measureList,
      widgetList: widgetList ?? this.widgetList,
      idMeal: idMeal ?? this.idMeal,
      index: index ?? this.index,
      recipeCategory: recipeCategory ?? this.recipeCategory,
      recipeArea: recipeArea ?? this.recipeArea,
    );
  }
}
