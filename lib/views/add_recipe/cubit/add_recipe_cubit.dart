import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/views/add_recipe/add_recipe_view.dart';

part 'add_recipe_state.dart';

class AddRecipeCubit extends Cubit<AddRecipeState> {
  AddRecipeCubit() : super(AddRecipeState());

  List<Widget>? widgetList = [];
  List<String?>? ingredientList = [];
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

  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _measureControllers = [];

  Future<String> getIdFromFirestore() async {
    final ref = FirebaseFirestore.instance
        .collection('recipes')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    final doc = await ref.get();
    final idMeal = doc.get('idMeal') as String;
    return idMeal;
  }

  Future<void>? addIngredientField() async {
    _ingredientControllers.add(TextEditingController());
    _measureControllers.add(TextEditingController());
    widgetList?.insert(
      state.index,
      Padding(
        padding: ProjectPaddings.cardMedium,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: IngredientName(
                ingredientController: _ingredientControllers[state.index],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _measureControllers[state.index],
                decoration: InputDecoration(
                  hintText: 'Amount',
                  suffixIcon: IconButton(
                    iconSize: 20,
                    onPressed: () async {
                      state.widgetList.removeAt(state.index);
                      _ingredientControllers.removeAt(state.index);
                      _measureControllers.removeAt(state.index);
                      emit(
                        state.copyWith(
                          widgetList: widgetList,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ).toVisible(state.index > 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    emit(
      state.copyWith(
        widgetList: widgetList,
      ),
    );
    return;
  }

  Future<String?> getIdMeal() async {
    final ref = FirebaseFirestore.instance.collection('recipes').doc().withConverter(
          fromFirestore: (snapshot, _) => Meals.fromFirestore(snapshot),
          toFirestore: (Meals meals, _) => meals.toFirestore(),
        );
    final docSnap = await ref.get();
    final idMeal = docSnap.data();
    return idMeal?.idMeal ?? '';
  }
}
