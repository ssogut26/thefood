import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/views/add_recipe/add_recipe_view.dart';

part 'add_recipe_state.dart';

class AddRecipeCubit extends Cubit<AddRecipeState> {
  AddRecipeCubit() : super(AddRecipeState());

  List<Widget> widgetList = [];
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
  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientAmountController = TextEditingController();

  void addValue(List<String>? ingredientList, List<String>? measureList) {
    emit(
      state.copyWith(
        ingredientList: ingredientList ?? [],
        measureList: measureList ?? [],
      ),
    );
  }

  void addIngredientField(
    TextEditingController ingredientNameController,
    TextEditingController ingredientAmountController,
  ) {
    widgetList.insert(
      0,
      Padding(
        padding: ProjectPaddings.cardMedium,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: IngredientName(controller: ingredientNameController),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: ingredientAmountController,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: removeIngredientField,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    emit(state.copyWith(widgetList: widgetList));
  }

  void removeIngredientField() {
    widgetList.removeAt(0);
    emit(state.copyWith(widgetList: widgetList));
  }

  void addRecipe() {
    for (final widget in widgetList) {
      ingredientList?.add(ingredientNameController.text);
    }
    emit(state.copyWith(ingredientList: state.ingredientList));
  }
}
