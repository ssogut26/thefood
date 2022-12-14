import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/core/services/search_service.dart';
import 'package:thefood/features/components/alerts.dart';
import 'package:thefood/features/components/extensions.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/products/models/categories.dart';
import 'package:thefood/products/models/ingredients.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/models/user.dart';
import 'package:thefood/products/views/add_recipe/cubit/add_recipe_cubit.dart';
import 'package:validators/validators.dart';

part '../../view_models/add_recipe_view_model.dart';

class AddRecipe extends StatefulWidget {
  // ignore: avoid_unused_constructor_parameters
  const AddRecipe({super.key});
  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  int index = 1;
  // it have bug
  Future<void> addIngredientField() async {
    ValueKey(index);
    if (mounted) {
      setState(() {
        _ingredientControllers?.insert(index, TextEditingController());
        _measureControllers?.insert(index, TextEditingController());
        widgetList.insert(
          index,
          Padding(
            key: ValueKey(index),
            padding: ProjectPaddings.cardMedium,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: IngredientName(
                    ingredientController:
                        _ingredientControllers?[index] ?? TextEditingController(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    controller: _measureControllers?[index],
                    decoration: InputDecoration(
                      hintText: 'Measure',
                      hintStyle: const TextStyle(
                        overflow: TextOverflow.visible,
                      ),
                      suffixIcon: IconButton(
                        constraints: const BoxConstraints(
                          maxWidth: 15,
                        ),
                        iconSize: 20,
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              index--;
                              widgetList.removeWhere(
                                (element) => element.key == ValueKey(index),
                              );
                              _ingredientControllers
                                  ?.removeWhere((element) => element == ValueKey(index));
                              _measureControllers
                                  ?.removeWhere((element) => element == index);
                            });
                          }
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
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _instructionController = TextEditingController();
    _youtubeController = TextEditingController();
    _sourceController = TextEditingController();
    _ingredientControllers = <TextEditingController>[];
    _measureControllers = <TextEditingController>[];
    _imageController = TextEditingController();
    widgetList.add(initialIngredient());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRecipeCubit(),
      child: Scaffold(
        appBar: _appBar(),
        body: BlocBuilder<AddRecipeCubit, AddRecipeState>(
          builder: (context, state) {
            return WillPopScope(
              key: UniqueKey(),
              onWillPop: () async {
                var isPop = false;
                await AlertWidgets.showActionDialog(
                  context,
                  'Alert',
                  const Text('Are you sure you want to exit?'),
                  [
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop(isPop = false);
                      },
                      child: Text(
                        ProjectTexts.cancel,
                        style: context.textTheme.bodyText2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, isPop = true);
                      },
                      child: Text(
                        ProjectTexts.yes,
                        style: context.textTheme.bodyText2,
                      ),
                    ),
                  ],
                );
                return isPop;
              },
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ProjectPaddings.pageLarge,
                    child: Column(
                      children: [
                        //Name

                        _headlineBox(context, ProjectTexts.recipeName),
                        BasicCustomField(
                          controller: _nameController,
                          hintText: ProjectTexts.recipeNameInput,
                        ),

                        //Category

                        _headlineBox(context, ProjectTexts.categoryName),
                        const CategoryDropDown(),

                        //Area

                        _headlineBox(context, ProjectTexts.areaName),
                        const AreaDropdown(),

                        //Ingredients

                        _headlineBox(context, ProjectTexts.recipeIngredients),
                        ...widgetList,
                        Padding(
                          padding: ProjectPaddings.cardMedium,
                          child: ElevatedButton(
                            onPressed: addIngredientField,
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        //Instructions

                        _headlineBox(context, ProjectTexts.recipeInstructions),
                        const InstructionInput(),

                        //Image

                        _headlineBox(context, ProjectTexts.image),
                        //Will be added with image picker
                        const AddImageField(),
                        _headlineBox(context, ProjectTexts.youtubeLink),

                        //Youtube Link
                        YoutubeField(
                          controller: _youtubeController,
                          hintText: ProjectTexts.youtubeInput,
                        ),

                        //Source Link
                        _headlineBox(context, ProjectTexts.source),
                        SourceField(
                          hintText: ProjectTexts.sourceInput,
                          controller: _sourceController,
                        ),

                        //Submit Button
                        const SendButton(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: context.dynamicHeight(0.08),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ProjectColors.lightGrey,
              ProjectColors.yellow,
            ],
          ),
        ),
      ),
      title: const Text(ProjectTexts.addRecipe),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionController.dispose();
    _youtubeController.dispose();
    _sourceController.dispose();
    widgetList.clear();
    _ingredientControllers?.forEach((element) => element?.dispose());
    _measureControllers?.forEach((element) => element?.dispose());
    _imageController.dispose();

    super.dispose();
  }
}
