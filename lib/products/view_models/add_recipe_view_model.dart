part of '../views/add_recipe/add_recipe_view.dart';

List<Widget> widgetList = [];
late TextEditingController _nameController;
late TextEditingController _youtubeController;
late TextEditingController _sourceController;
late TextEditingController _instructionController;
late TextEditingController _imageController;
late List<TextEditingController?>? _ingredientControllers;
late List<TextEditingController?>? _measureControllers;
final _formKey = GlobalKey<FormState>();

int index = 1;

Widget initialIngredient() {
  const initialIndex = 0;
  _ingredientControllers?.add(TextEditingController());
  _measureControllers?.add(TextEditingController());
  return Padding(
    padding: ProjectPaddings.cardMedium,
    child: Row(
      children: [
        Expanded(
          flex: 5,
          child: IngredientName(
            ingredientController:
                _ingredientControllers?[initialIndex] ?? TextEditingController(),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        MeasureField(
          measureControllers: _measureControllers,
          index: initialIndex,
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
        decoration: const BoxDecoration(
          color: ProjectColors.containerYellow,
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

class SendButton extends ConsumerStatefulWidget {
  const SendButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<SendButton> {
  int id = 0;
  Future<int> getRecipeId() async {
    final recipeId = FirebaseFirestore.instance.collection('recipes').get();
    await recipeId.then((value) async {
      id = value.docs.length + 1;
      final result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('idMeal', isEqualTo: id.toString())
          .get()
          .then((value) {
        if (value.size > 0) return true;
        return false;
      });
      switch (result) {
        case true:
          id + 10;
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
    bool checkNull,
    String idMeal,
  ) async {
    final result = await FirebaseFirestore.instance
        .collection('recipes')
        .where('strMeal', isEqualTo: _nameController.text)
        .get()
        .then((value) {
      if (value.size > 0) return true;
      return false;
    });
    if (result == true) {
      return AlertWidgets.showSnackBar(
        context,
        'Recipe already exists',
      );

      // it has a bug only sends to firestore after second time user sended.
    } else if (checkNull == false) {
      return AlertWidgets.showSnackBar(
        context,
        'Ingredient or measure cannot be empty',
      );
    } else {
      try {
        final goRecipeDocument =
            FirebaseFirestore.instance.collection('recipes').doc(id.toString());
        final userDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(
              'recipes',
            )
            .doc(idMeal);

        await goRecipeDocument.set(recipe);

        await goRecipeDocument.update(user);
        if (result == false) {
          await userDoc.set(userDocData);
        }
        AlertWidgets.showSnackBar(
          context,
          'Recipe added',
        );
        Navigator.pop(context);
      } catch (e) {
        return AlertWidgets.showSnackBar(
          context,
          'Something went wrong',
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getRecipeId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddRecipeCubit, AddRecipeState>(
      builder: (context, state) {
        return SizedBox(
          width: context.width * 0.6,
          height: context.height * 0.06,
          child: ElevatedButton(
            onPressed: () async {
              final userCountry = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((value) => value.data()?['country']);
              final currentUser = FirebaseAuth.instance.currentUser;
              if (_formKey.currentState?.validate() ?? false) {
                context.read<AddRecipeCubit>().addValue(
                      _ingredientControllers
                          ?.map((e) => e?.text.toString() ?? '')
                          .toList(),
                      _measureControllers?.map((e) => e?.text.toString() ?? '').toList(),
                    );

                final recipe = Meals().copyWith(
                  idMeal: id.toString(),
                  strMeal: _nameController.text,
                  strArea: state.recipeArea,
                  strCategory: state.recipeCategory,
                  strIngredients: state.ingredientList,
                  strMeasures: state.measureList,
                  strInstructions: _instructionController.text,
                  strMealThumb: _imageController.text,
                  strSource: _sourceController.text,
                  strYoutube: _youtubeController.text,
                  dateModified: DateTime.now().toString(),
                );
                final user = UserModels(
                  userId: currentUser?.uid,
                  name: currentUser?.displayName,
                  email: currentUser?.email,
                  country: userCountry as String?,
                  photoURL: currentUser?.photoURL,
                );
                checkName(
                  recipe.toJson(),
                  user.toJson(),
                  recipe.toJson(),
                  state.ingredientList?.isNotNullOrEmpty ?? false,
                  id.toString(),
                );
              }
            },
            child: Text(ProjectTexts.send, style: context.textTheme.headline3),
          ),
        );
      },
    );
  }
}

class SourceField extends StatelessWidget {
  const SourceField({
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
      child: TextFormField(
        validator: (value) {
          if ((value?.isNotEmpty == true) &&
              isURL(
                    value,
                    requireProtocol: true,
                    protocols: ['http', 'https'],
                  ) ==
                  false) {
            return 'Please enter a valid url it should start with http or https';
          }
          return null;
        },
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
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
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
      child: TextFormField(
        validator: (value) {
          if ((value?.isNotEmpty == true) &&
              isURL(
                    value,
                    requireProtocol: true,
                    protocols: ['http', 'https'],
                  ) ==
                  false) {
            return 'Please enter a valid url it should start with http or https';
          }
          return null;
        },
        controller: _controller,
        decoration: InputDecoration(
          label: Text(_hintText),
        ),
      ),
    );
  }
}

class AddImageField extends StatelessWidget {
  const AddImageField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value.isNullOrEmpty) {
                return 'Please enter an image url';
              } else if (isURL(
                    value,
                    requireProtocol: true,
                    protocols: ['http', 'https'],
                  ) ==
                  false) {
                return 'Please enter a valid url it should start with http or https';
              } else {
                return null;
              }
            },
            controller: _imageController,
            decoration: const InputDecoration(
              hintText: ProjectTexts.imageInput,
            ),
          ),
        ],
      ),
    );
  }
}

class InstructionInput extends StatelessWidget {
  const InstructionInput({
    super.key,
  });
  String? Function(String?)? validator() {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please write instructions';
      }
      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ProjectPaddings.cardMedium,
      height: context.dynamicHeight(0.15),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: ProjectTexts.instructionInput,
        ),
        validator: validator(),
        maxLength: 3500,
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
      flex: 4,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ingredient';
                  }
                  return null;
                },
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
              return Padding(
                padding: ProjectPaddings.cardMedium,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    child: SizedBox(
                      width: context.dynamicWidth(0.87),
                      height: context.dynamicHeight(0.3),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        padding: ProjectPaddings.textHorizontalMedium,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final ingredient = options.elementAt(index);
                          return InkWell(
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
                                        child: CustomLottieLoading(
                                          path: AssetsPath.progression,
                                          onLoaded: (composition) {
                                            downloadProgress.progress;
                                          },
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
                    ),
                  ),
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = _nameController.text;
          if (value.isEmpty) {
            return 'Please write a recipe name';
          }
          return null;
        },
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
            validator: (value) {
              if (value == null) {
                return 'Please select an area';
              }
              return null;
            },
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
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
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
