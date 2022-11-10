import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/services/search_service.dart';
import 'package:thefood/views/add_recipe/cubit/add_recipe_cubit.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<Widget> widgetList = [];
  final List<TextEditingController> _ingredientControllers = [];
  final List<TextEditingController> _measureControllers = [];

  Future<void> addIngredientField() async {
    final index = widgetList.length;
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
  }

  Widget initialIngredient() {
    _ingredientControllers.add(TextEditingController());
    _measureControllers.add(TextEditingController());
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: IngredientName(
              ingredientController: _ingredientControllers[0],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _measureControllers[0],
              decoration: const InputDecoration(
                hintText: 'Amount',
              ),
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  List<String> ingredientList = [];
  Meals? test;
  late Future<List<MealCategory>?> categories;
  @override
  void initState() {
    widgetList.add(initialIngredient());
    categories = NetworkManager.instance.getCategories();
    super.initState();
  }

  String categoryValue = 'Select Category';
  final int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddRecipeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Recipe'),
        ),
        body: BlocBuilder<AddRecipeCubit, AddRecipeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: ProjectPaddings.pageLarge,
                child: Column(
                  children: [
                    _headlineBox(context, 'NAME*'),
                    NameInput(nameController: _nameController),
                    _headlineBox(context, 'CATEGORY*'),
                    const CategoryDropDown(),
                    _headlineBox(context, 'AREA*'),
                    const AreaDropdown(),
                    _headlineBox(context, 'INGREDIENTS*'),
                    ...widgetList,
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: ElevatedButton(
                        onPressed: addIngredientField,
                        child: const Icon(Icons.add),
                      ),
                    ),
                    _headlineBox(context, 'INSTRUCTIONS*'),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          height: 5 * 24.0,
                          child: TextFormField(
                            maxLength: 2000,
                            controller: _instructionController,
                            maxLines: 20,
                            decoration: const InputDecoration(
                              hintText: 'Enter a description',
                            ),
                          ),
                        ),
                      ],
                    ),
                    _headlineBox(context, 'IMAGE*'),
                    //Will be added with image picker
                    Column(
                      children: [
                        Padding(
                          padding: ProjectPaddings.cardMedium,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.image,
                            ),
                            label: const Text('Select from Gallery'),
                          ),
                        ),
                        Padding(
                          padding: ProjectPaddings.cardMedium,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text('Shot from Camera'),
                            icon: const Icon(Icons.camera_alt),
                          ),
                        ),
                      ],
                    ),
                    _headlineBox(context, 'Youtube'),
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: TextField(
                        controller: _youtubeController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a youtube link',
                        ),
                      ),
                    ),
                    _headlineBox(context, 'Source'),
                    Padding(
                      padding: ProjectPaddings.cardMedium,
                      child: TextField(
                        controller: _sourceController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a source link',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          context.read<AddRecipeCubit>().addValue(
                                _ingredientControllers.map((e) => e.text).toList(),
                                _measureControllers.map((e) => e.text).toList(),
                              );
                        });

                        final recipe = Meals().copyWith(
                          strMeal: _nameController.text,
                          strArea: state.recipeArea,
                          strCategory: state.recipeCategory,
                          strIngredients: state.ingredientList,
                          strMeasures: state.measureList,
                          strInstructions: _instructionController.text,
                          strYoutube: _youtubeController.text,
                        );
                        await FirebaseFirestore.instance
                            .collection('recipes')
                            .doc(_nameController.text)
                            .set(recipe.toJson());
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding _headlineBox(BuildContext context, String text) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: SizedBox(
        width: context.width,
        height: context.height * 0.05,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.yellow[200],
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: context.textTheme.headline2,
            ),
          ),
        ),
      ),
    );
  }
}

class IngredientName extends StatefulWidget {
  const IngredientName({
    super.key,
    required TextEditingController ingredientController,
  }) : _ingredientController = ingredientController;

  final TextEditingController _ingredientController;

  @override
  State<IngredientName> createState() => _IngredientNameState();
}

class _IngredientNameState extends State<IngredientName> {
  late final ISearchService _searchService;

  @override
  void initState() {
    _searchService = SearchService(Dio(BaseOptions(baseUrl: EndPoints.baseUrl)));
    super.initState();
  }

  CancelableOperation<void>? _operation;

  Future<List<MealsIngredient>> search(String key) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 500),
      ),
    );
    var ingredients = <MealsIngredient>[];
    await _operation?.value.whenComplete(() async {
      ingredients = await _searchService.fetchIngredients(key) ?? [];
    });

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddRecipeCubit>(
      create: (context) => AddRecipeCubit(),
      child: BlocBuilder<AddRecipeCubit, AddRecipeState>(
        builder: (context, state) {
          return RawAutocomplete<MealsIngredient>(
            textEditingController: widget._ingredientController,
            focusNode: FocusNode(),
            fieldViewBuilder: (context, textEditingController, focusNode, onChanged) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  onChanged();
                },
                decoration: const InputDecoration(
                  hintText: 'Ingredient',
                ),
              );
            },
            optionsViewBuilder: (context, onSelected, options) {
              return Material(
                elevation: 4,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: ProjectPaddings.textMedium,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final ingredient = options.elementAt(index);
                    return GestureDetector(
                      onTap: () async {
                        onSelected(ingredient);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: ProjectPaddings.textMedium,
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                  ),
                                ),
                                imageUrl:
                                    '${EndPoints.ingredientsImages + ingredient.strIngredient}-small.png',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(ingredient.strIngredient),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            displayStringForOption: (option) {
              return option.strIngredient;
            },
            optionsBuilder: (TextEditingValue textEditingValue) async {
              return await search(textEditingValue.text);
            },
          );
        },
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          hintText: 'Enter your recipe name',
        ),
      ),
    );
  }
}

class AreaDropdown extends StatefulWidget {
  const AreaDropdown({
    super.key,
  });

  @override
  State<AreaDropdown> createState() => _AreaDropdownState();
}

class _AreaDropdownState extends State<AreaDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: BlocBuilder<AddRecipeCubit, AddRecipeState>(
        builder: (context, state) {
          return DropdownButtonFormField(
            hint: const Text('Select Area'),
            items: [
              for (var index = 0; index < countryFlagMap.length; index++)
                DropdownMenuItem(
                  value: countryFlagMap.keys.elementAt(index),
                  child: Row(
                    children: [
                      Padding(
                        padding: context.onlyRightPaddingLow,
                        child: CachedNetworkImage(
                          imageUrl: countryFlagMap.values.elementAt(index),
                          height: 32,
                          width: 32,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                      Text(countryFlagMap.keys.elementAt(index)),
                    ],
                  ),
                ),
            ],
            onChanged: (value) {
              setState(() {
                state.recipeArea = value.toString();
              });
            },
          );
        },
      ),
    );
  }
}

class CategoryDropDown extends StatefulWidget {
  const CategoryDropDown({
    super.key,
  });

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  int? _selectedCategory = 0;
  late Future<List<MealCategory>?> categories;
  @override
  void initState() {
    categories = NetworkManager.instance.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: BlocBuilder<AddRecipeCubit, AddRecipeState>(
        builder: (context, state) {
          return FutureBuilder<List<MealCategory>?>(
            future: categories,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.isNotNullOrEmpty) {
                final data = snapshot.data;
                return DropdownButtonFormField(
                  hint: const Text('Select Category'),
                  items: [
                    for (var index = 0; index < data!.length; index++)
                      DropdownMenuItem(
                        value: index,
                        child: Text(data[index].strCategory ?? ''),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      state.recipeCategory = data[_selectedCategory!].strCategory ?? '';
                    });
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
    );
  }
}
