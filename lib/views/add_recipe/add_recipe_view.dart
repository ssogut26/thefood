import 'package:cached_network_image/cached_network_image.dart';
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
  final List<Widget> _widgetList1 = [
    Row(
      children: [
        Flexible(
          flex: 3,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Ingredient',
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Amount',
            ),
          ),
        ),
      ],
    ),
  ];

  final List<TextEditingController> _controllers = [];

  void addIngredientField(
    int index,
    TextEditingController controllertxt,
    TextEditingController ingredientAmountController,
  ) {
    final ingredients = ingredientList[index];
    _widgetList1.insert(
      0,
      Padding(
        padding: ProjectPaddings.cardMedium,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: IngredientName(controller: controllertxt),
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
                    onPressed: () {},
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
  }

  List<String> ingredientList = [];
  final bool _displayNewTextField = false;
  Meals? test;
  @override
  void initState() {
    super.initState();
  }

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
                    const NameInput(),
                    _headlineBox(context, 'CATEGORY'),
                    const CategoryDropDown(),
                    _headlineBox(context, 'AREA'),
                    const AreaDropdown(),
                    _headlineBox(context, 'INGREDIENTS'),
                    ListView.builder(
                      itemCount: _widgetList1.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        const i = 20;
                        if (i < _widgetList1.length) {
                          _controllers.add(TextEditingController());
                        }
                        return _widgetList1[index];
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          var index = _widgetList1.length;
                          _widgetList1.insert(
                            0,
                            Padding(
                              padding: ProjectPaddings.cardMedium,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: IngredientName(
                                      controller: _controllers[index],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Amount',
                                        suffixIcon: IconButton(
                                          iconSize: 20,
                                          onPressed: () {
                                            setState(() {
                                              _widgetList1.removeAt(0);
                                            });
                                          },
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
                          index++;
                        });
                      },
                      child: const Text('Add Ingredient'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          context
                              .read<AddRecipeCubit>()
                              .addValue(_controllers.map((e) => e.text).toList());
                        });
                        print(_controllers.map((e) => e.text).toList().length);
                        _controllers.clear();
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter your recipe name',
        ),
      ),
    );
  }
}

class AreaDropdown extends StatelessWidget {
  const AreaDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: DropdownButtonFormField(
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
        onChanged: (value) {},
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
      child: FutureBuilder<List<MealCategory>?>(
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
                });
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
