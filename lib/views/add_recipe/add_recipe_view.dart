import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/network_manager.dart';
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

  void addIngredientField(
    int index,
    TextEditingController controllertxt,
    TextEditingController ingredientAmountController,
  ) {
    widgetList.add(
      Padding(
        padding: ProjectPaddings.cardMedium,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: IngredientName(
                controller: _ingredientControllers[index],
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
                        widgetList.removeWhere(
                          (element) => element == widgetList[index],
                        );
                        _ingredientControllers.removeWhere(
                          (element) => element == _ingredientControllers[index],
                        );
                        _measureControllers.removeWhere(
                          (element) => element == _measureControllers[index],
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ).toVisible(index >= 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _nameController = TextEditingController();
  List<String> ingredientList = [];
  Meals? test;
  late Future<List<MealCategory>?> categories;
  @override
  void initState() {
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
        body: BlocConsumer<AddRecipeCubit, AddRecipeState>(
          listener: (previous, current) {
            if (previous != current) {
              setState(() {});
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: ProjectPaddings.pageLarge,
                child: Column(
                  children: [
                    _headlineBox(context, 'NAME'),
                    NameInput(nameController: _nameController),
                    _headlineBox(context, 'CATEGORY'),
                    const CategoryDropDown(),
                    _headlineBox(context, 'AREA'),
                    const AreaDropdown(),
                    _headlineBox(context, 'INGREDIENTS'),
                    ListView.builder(
                      itemCount: widgetList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return widgetList[index];
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // create every index for widgetList

                        _ingredientControllers.add(TextEditingController());
                        _measureControllers.add(TextEditingController());
                      },
                      child: const Text('Add Ingredient'),
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
                        );
                        await FirebaseFirestore.instance
                            .collection('recipes')
                            .doc()
                            .set(recipe.toJson());
                      },
                      child: const Text('Save'),
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
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  State<IngredientName> createState() => _IngredientNameState();
}

class _IngredientNameState extends State<IngredientName> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddRecipeCubit, AddRecipeState>(
      builder: (context, state) {
        return TextFormField(
          controller: widget._controller,
          decoration: const InputDecoration(
            hintText: 'Ingredient',
          ),
        );
      },
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
