import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/compoments/models/categories.dart';
import 'package:thefood/features/compoments/models/ingredients.dart';
import 'package:thefood/features/compoments/views/add_recipe/cubit/add_recipe_cubit.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/services/search_service.dart';

part 'add_recipe_widgets.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  int index = 1;

  Future<void> addIngredientField() async {
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
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _measureControllers[index],
                  decoration: InputDecoration(
                    hintText: 'Amount',
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
                ),
              ),
            ],
          ),
        ),
      );
    });
    index++;
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _instructionController = TextEditingController();
    _youtubeController = TextEditingController();
    _sourceController = TextEditingController();
    if (widgetList.length == 1) {
      widgetList.clear();
      _ingredientControllers.clear();
      _measureControllers.clear();
      _nameController.clear();
      _instructionController.clear();
      _imageController.clear();
      _youtubeController.clear();
      _sourceController.clear();
      _imageController.clear();
    }
    widgetList.add(initialIngredient());
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
                    BasicCustomField(
                      controller: _nameController,
                      hintText: ProjectTexts.recipeNameInput,
                    ),
                    _headlineBox(context, ProjectTexts.categoryName),
                    const CategoryDropDown(),
                    _headlineBox(context, ProjectTexts.areaName),
                    const AreaDropdown(),
                    _headlineBox(context, ProjectTexts.ingredients),
                    ...widgetList,
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: ElevatedButton(
                        onPressed: addIngredientField,
                        child: const Icon(Icons.add),
                      ),
                    ),
                    _headlineBox(context, ProjectTexts.instructions),
                    const InstructionInput(),
                    _headlineBox(context, ProjectTexts.image),
                    //Will be added with image picker
                    const AddImageButtons(),
                    _headlineBox(context, ProjectTexts.youtubeLink),
                    BasicCustomField(
                      controller: _youtubeController,
                      hintText: ProjectTexts.youtubeInput,
                    ),
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
