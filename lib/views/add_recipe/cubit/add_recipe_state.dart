part of 'add_recipe_cubit.dart';

class AddRecipeState extends Equatable {
  AddRecipeState({this.ingredientList = const [], this.widgetList = const []});

  List<String> ingredientList = [];
  List<Widget> widgetList = [];

  @override
  List<Object> get props => [ingredientList, widgetList];

  AddRecipeState copyWith({
    List<String>? ingredientList,
    List<Widget>? widgetList,
  }) {
    return AddRecipeState(
      ingredientList: ingredientList ?? this.ingredientList,
      widgetList: widgetList ?? this.widgetList,
    );
  }
}
