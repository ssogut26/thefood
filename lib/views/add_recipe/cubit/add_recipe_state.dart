part of 'add_recipe_cubit.dart';

class AddRecipeState extends Equatable {
  AddRecipeState({
    this.ingredientList = const [
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    ],
    this.measureList = const [],
    this.widgetList = const [],
    this.recipeCategory,
    this.recipeArea,
  });

  List<String?>? ingredientList = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List<String?>? measureList = [];
  List<Widget> widgetList = [];
  String? recipeCategory;
  String? recipeArea;

  @override
  List<Object?> get props =>
      [ingredientList, measureList, widgetList, recipeCategory, recipeArea];

  AddRecipeState copyWith({
    List<String?>? ingredientList,
    List<String?>? measureList,
    List<Widget>? widgetList,
    String? recipeCategory,
    String? recipeArea,
  }) {
    return AddRecipeState(
      ingredientList: ingredientList ?? this.ingredientList,
      measureList: measureList ?? this.measureList,
      widgetList: widgetList ?? this.widgetList,
      recipeCategory: recipeCategory ?? this.recipeCategory,
      recipeArea: recipeArea ?? this.recipeArea,
    );
  }
}
