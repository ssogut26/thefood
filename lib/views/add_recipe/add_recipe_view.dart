import 'dart:async';

import 'package:async/async.dart' show CancelableOperation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/models/user.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/services/search_service.dart';
import 'package:thefood/views/add_recipe/cubit/add_recipe_cubit.dart';

part 'add_recipe_widgets.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  int index = 1;
  Future<void>? addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
      _measureControllers.add(TextEditingController());
      widgetList.insert(
        index,
        Padding(
          padding: ProjectPaddings.cardMedium,
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: IngredientName(
                  ingredientController: _ingredientControllers[index],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              MeasureField(
                measureControllers: _measureControllers,
                index: index,
                suffixIcon: IconButton(
                  iconSize: 20,
                  onPressed: () {
                    setState(() {
                      index--;
                      widgetList.removeAt(index);
                      _ingredientControllers.removeAt(index);
                      _measureControllers.removeAt(index);
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ).toVisible(index > 0),
              ),
            ],
          ),
        ),
      );
    });
    index++;
    return null;
  }

  @override
  void initState() {
    widgetList.add(initialIngredient());
    _nameController = TextEditingController();
    _sourceController = TextEditingController();
    _youtubeController = TextEditingController();
    _instructionController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRecipeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(ProjectTexts.addRecipe),
        ),
        body: BlocBuilder<AddRecipeCubit, AddRecipeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: ProjectPaddings.pageLarge,
                child: Column(
                  children: [
                    _headlineBox(context, ProjectTexts.recipeName),
                    NameInput(nameController: _nameController),
                    _headlineBox(context, ProjectTexts.categoryName),
                    const CategoryDropDown(),
                    _headlineBox(context, ProjectTexts.areaName),
                    const AreaDropdown(),
                    _headlineBox(context, ProjectTexts.recipeIngredients),
                    ...widgetList,
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: state.index < 20
                          ? ElevatedButton(
                              onPressed: addIngredientField,
                              child: const Icon(Icons.add),
                            )
                          : const SizedBox.shrink(),
                    ),
                    _headlineBox(context, ProjectTexts.recipeInstructions),
                    const InstructionInput(),
                    _headlineBox(context, ProjectTexts.image),
                    //Will be added with image picker
                    const AddImageButtons(),
                    _headlineBox(context, ProjectTexts.youtubeLink),
                    const YoutubeField(),
                    _headlineBox(context, ProjectTexts.source),
                    const SourceField(),
                    const SendButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
