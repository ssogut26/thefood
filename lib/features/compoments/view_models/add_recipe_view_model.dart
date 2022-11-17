part of '../views/add_recipe/add_recipe_view.dart';

List<Widget> widgetList = [];
late TextEditingController _nameController;
late TextEditingController _youtubeController;
late TextEditingController _sourceController;
late TextEditingController _instructionController;
final TextEditingController _imageController = TextEditingController();
late List<TextEditingController?>? _ingredientControllers;
late List<TextEditingController?>? _measureControllers;

int index = 1;
Widget initialIngredient() {
  index = 0;
  _ingredientControllers?.add(TextEditingController());
  _measureControllers?.add(TextEditingController());
  return Padding(
    padding: ProjectPaddings.cardMedium,
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: IngredientName(
            ingredientController: _ingredientControllers?[0] ?? TextEditingController(),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        MeasureField(
          measureControllers: _measureControllers,
          index: index,
          suffixIcon: const SizedBox.shrink(),
        ),
      ],
    ),
  );
}

List<String> ingredientList = [];

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

class SendButton extends StatefulWidget {
  const SendButton({
    super.key,
  });

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  late int id;
  Future<int> getRecipeId() async {
    final recipeId = FirebaseFirestore.instance.collection('recipes').get();
    await recipeId.then((value) async {
      id = value.docs.length + 1;
      final ref = await FirebaseFirestore.instance
          .collection('recipes')
          .where('idMeal', isEqualTo: id.toString())
          .get()
          .then((value) {
        if (value.size > 0) return true;
        return false;
      });
      switch (ref) {
        case true:
          id++;
          break;
        case false:
          break;
      }
    });
    return id;
  }

  dynamic checkName(
    Map<String, dynamic> recipe,
    Map<String, dynamic> user,
    Map<String, dynamic> userDocData,
  ) async {
    final ref = await FirebaseFirestore.instance
        .collection('recipes')
        .where('strMeal', isEqualTo: _nameController.text)
        .get()
        .then((value) {
      if (value.size > 0) return true;
      return false;
    });
    if (ref == true) {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe already exists'),
        ),
      );
    } else {
      final goRecipeDocument =
          FirebaseFirestore.instance.collection('recipes').doc(id.toString());
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(
            'recipes',
          )
          .doc();
      await goRecipeDocument.set(recipe);
      await goRecipeDocument.update(user);
      await userDoc.set(userDocData);
    }
    return checkName;
  }

  @override
  void initState() {
    getRecipeId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddRecipeCubit, AddRecipeState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () async {
            setState(() {
              context.read<AddRecipeCubit>().addValue(
                    _ingredientControllers
                        ?.map((e) => e?.text ?? '')
                        .toList()
                        .cast<String>(),
                    _measureControllers
                        ?.map((e) => e?.text ?? '')
                        .toList()
                        .cast<String>(),
                  );
            });
            final recipe = Meals().copyWith(
              idMeal: id.toString(),
              strMeal: _nameController.text,
              strArea: state.recipeArea,
              strCategory: state.recipeCategory,
              strIngredients: state.ingredientList?.cast<String?>(),
              strMeasures: state.measureList?.cast<String?>(),
              strInstructions: _instructionController.text,
              strMealThumb: _imageController.text,
              strSource: _sourceController.text,
              strYoutube: _youtubeController.text,
            );
            final user = UserModels(
              id: FirebaseAuth.instance.currentUser?.uid,
              name: FirebaseAuth.instance.currentUser?.displayName,
            );
            checkName(recipe.toJson(), user.toJson(), recipe.toJson());
          },
          child: const Text(ProjectTexts.send),
        );
      },
    );
  }
}

class SourceField extends StatelessWidget {
  const SourceField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextField(
        decoration: const InputDecoration(
          label: Text(ProjectTexts.sourceInput),
        ),
        controller: _sourceController,
      ),
    );
  }
}

class BasicCustomField extends StatelessWidget {
  const BasicCustomField({
    super.key,
    required TextEditingController controller,
    required String hintText,
  })  : _controller = controller,
        _hintText = hintText;
  final TextEditingController _controller;
  final String _hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: _hintText,
        ),
      ),
    );
  }
}

class YoutubeField extends StatelessWidget {
  const YoutubeField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: TextField(
        controller: _youtubeController,
      ),
    );
  }
}

class AddImageButtons extends StatelessWidget {
  const AddImageButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _imageController,
        ),
        Padding(
          padding: ProjectPaddings.cardMedium,
          child: SizedBox(
            width: context.dynamicWidth(0.5),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.image,
              ),
              label: const Text(ProjectTexts.pickGallery),
            ),
          ),
        ),
        Padding(
          padding: ProjectPaddings.cardMedium,
          child: SizedBox(
            width: context.dynamicWidth(0.5),
            child: ElevatedButton.icon(
              onPressed: () {},
              label: const Text(ProjectTexts.pickCamera),
              icon: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      ],
    );
  }
}

class InstructionInput extends StatelessWidget {
  const InstructionInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      height: context.dynamicHeight(0.15),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: ProjectTexts.instructionInput,
        ),
        maxLength: 2000,
        controller: _instructionController,
        maxLines: 20,
      ),
    );
  }
}

class MeasureField extends StatefulWidget {
  const MeasureField({
    super.key,
    required List<TextEditingController?>? measureControllers,
    required Widget? suffixIcon,
    required int index,
  })  : _measureControllers = measureControllers,
        _suffixIcon = suffixIcon,
        _index = index;

  final List<TextEditingController?>? _measureControllers;
  final int _index;
  final Widget? _suffixIcon;

  @override
  State<MeasureField> createState() => _MeasureFieldState();
}

class _MeasureFieldState extends State<MeasureField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: TextFormField(
        controller: widget._measureControllers?[widget._index],
        decoration: InputDecoration(
          hintText: ProjectTexts.measureInput,
          suffixIcon: widget._suffixIcon,
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
      ingredients = await _searchService.fetchIngredients(key.capitalize()) ?? [];
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
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onFieldSubmitted: (value) {
                  onFieldSubmitted();
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
                  padding: ProjectPaddings.textHorizontalMedium,
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
                              padding: ProjectPaddings.textHorizontalMedium,
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
                                    '${'${EndPoints.ingredientsImages}${ingredient.strIngredient}'}-small.png',
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(ingredient.strIngredient ?? ''),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            displayStringForOption: (option) {
              return option.strIngredient ?? '';
            },
            optionsBuilder: (TextEditingValue textEditingValue) async {
              return textEditingValue.text.isEmpty
                  ? <MealsIngredient>[]
                  : await search(textEditingValue.text);
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
            hint: const Text(ProjectTexts.selectArea),
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
                  hint: const Text(ProjectTexts.selectCategory),
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
              }
              return DropdownButtonFormField(
                hint: const Text(ProjectTexts.selectCategory),
                items: const [],
                onChanged: (value) {},
              );
            },
          );
        },
      ),
    );
  }
}

extension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
