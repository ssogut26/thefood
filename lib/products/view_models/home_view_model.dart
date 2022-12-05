part of '../views/home/home_view.dart';

late int selectedIndex;
late int dataLength;
late String categoryName;
int itemLength() {
  if (dataLength < 4) {
    return dataLength;
  }
  return 4;
}

List<double> ratings = [];
Future<Widget> getRatings(int index, BuildContext context, String mealId) async {
  ratings = <double>[];
  final ref = FirebaseFirestore.instance.collection('reviews').doc(mealId).get();
  await ref.then((value) {
    if (value.exists) {
      final data = value.data()?['review'] as List;
      for (var i = 0; i < data.length; i++) {
        ratings.add(data[i]['rating'] as double);
      }
    }
  });
  if (ratings.isEmpty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProjectWidgets.buildRatingStar(0),
        Text('(${ratings.length})', style: context.textTheme.headline5),
      ],
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ProjectWidgets.buildRatingStar(ratings.average),
      Text('(${ratings.length})', style: context.textTheme.headline5),
    ],
  );
}

final GlobalKey<ScaffoldState> _key = GlobalKey();
final _auth = FirebaseAuth.instance;

class _AlignedText extends StatelessWidget {
  const _AlignedText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class ChangeCategory extends StatefulWidget {
  const ChangeCategory({super.key});

  @override
  State<ChangeCategory> createState() => _ChangeCategoryState();
}

class _ChangeCategoryState extends State<ChangeCategory> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              height: context.dynamicHeight(0.07),
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.mealCategory?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = state.mealCategory?[index];
                  if (data == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          final categoryName = data.strCategory ?? '';
                          if (context
                                  .read<HomeCubit>()
                                  .mealCacheManager
                                  .getItem(categoryName)
                                  ?.meals
                                  ?.isNotEmpty ??
                              false) {
                            state.categoryMealItems = context
                                .read<HomeCubit>()
                                .mealCacheManager
                                .getItem(categoryName);
                          } else {
                            state.categoryMealItems = await context
                                .read<HomeCubit>()
                                .getMealsByCategory(categoryName);
                            if (mounted) {
                              setState(() {
                                selectedIndex = index;
                              });
                            }
                          }
                        },
                        child: WholeCategoryCard(data: data, index: index),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  TextButton(
                    child: Text(
                      'See all',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    onPressed: () {
                      context.pushNamed(
                        'category',
                        params: {
                          'name':
                              state.mealCategory!.elementAt(selectedIndex).strCategory ??
                                  '',
                          'image': state.mealCategory!
                                  .elementAt(selectedIndex)
                                  .strCategoryThumb ??
                              '',
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class WholeCategoryCard extends StatelessWidget {
  const WholeCategoryCard({
    super.key,
    required this.data,
    required this.index,
  });

  final MealCategory? data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selectedIndex == index ? ProjectColors.yellow : ProjectColors.white,
      child: Row(
        children: [
          CardCategoryImage(data: data),
          CardCategoryName(data: data),
        ],
      ),
    );
  }
}

class CardCategoryImage extends StatelessWidget {
  const CardCategoryImage({
    super.key,
    required this.data,
  });

  final MealCategory? data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ProjectColors.mainWhite,
      child: CachedNetworkImage(
        imageUrl: data?.strCategoryThumb ?? '',
        height: 32,
        width: 32,
      ),
    );
  }
}

class CardCategoryName extends StatelessWidget {
  const CardCategoryName({
    super.key,
    required this.data,
  });

  final MealCategory? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.textHorizontalSmall,
      child: Text(
        data?.strCategory ?? '',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

class CategoryMeals extends StatefulWidget {
  const CategoryMeals({super.key});

  @override
  State<CategoryMeals> createState() => _CategoryMealsState();
}

class _CategoryMealsState extends State<CategoryMeals> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        if (previous.mealsByCategory != current.mealsByCategory) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              isLoading = !isLoading;
            });
          });
          return isLoading = true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        dataLength = state.mealsByCategory?.meals?.length ?? 0;
        return GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: _categoryMealGridDelegate(context),
          shrinkWrap: true,
          itemCount: itemLength(),
          itemBuilder: (context, index) {
            final data = state.mealsByCategory?.meals?[index];
            if (data == null) {
              return const SizedBox.shrink();
            }
            return isLoading
                ? Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.lowBorderRadius,
                    ),
                    color: ProjectColors.secondWhite,
                    child: Center(
                      child: CustomLottieLoading(
                        path: AssetsPath.progression,
                        onLoaded: (composition) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                      ),
                    ),
                  )
                : SizedBox(
                    height: context.dynamicHeight(0.27),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            context.pushNamed(
                              'details',
                              params: {
                                'name': data.strMeal ?? '',
                                'image': data.strMealThumb ?? '',
                                'id': data.idMeal ?? '',
                              },
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: MealName(data: data),
                              ),
                              Align(
                                alignment: const Alignment(0, 0.8),
                                child: FutureBuilder(
                                  future: ProjectWidgets.getRatings(
                                    index,
                                    ratings,
                                    context,
                                    data.idMeal ?? '',
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data ?? const SizedBox.shrink();
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: CircleMealImage(data: data),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }

  SliverGridDelegateWithMaxCrossAxisExtent _categoryMealGridDelegate(
    BuildContext context,
  ) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      crossAxisSpacing: context.dynamicWidth(0.05),
      mainAxisSpacing: context.dynamicWidth(0.02),
      maxCrossAxisExtent: context.dynamicWidth(0.5),
      mainAxisExtent: context.dynamicHeight(0.27),
    );
  }
}

Scaffold _noConnectionText() {
  return const Scaffold(
    body: Center(
      child: Text(ProjectTexts.offline),
    ),
  );
}

Center _loadingAnim(isLoading) {
  return Center(
    child: CustomLottieLoading(
      path: AssetsPath.progression,
      onLoaded: (composition) {
        isLoading = false;
      },
    ),
  );
}

Column _noConnection() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: Image.asset(AssetsPath.noConnectionImage)),
      const Text(
        ProjectTexts.noConnection,
      ),
    ],
  );
}

BlocBuilder<HomeCubit, HomeState> _homeBody() {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      return Scaffold(
        key: _key,
        appBar: _appBar(context),
        endDrawer: _Drawer(auth: _auth),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: ProjectPaddings.pageLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _SearchBar(),
                  if (state.mealCategory.isNotNullOrEmpty)
                    const ChangeCategory()
                  else
                    const CategoryShimmer(),
                  if (state.mealsByCategory?.meals?.isNotNullOrEmpty ?? false)
                    const CategoryMeals()
                  else
                    const CategoryMealShimmer(
                      itemCount: 4,
                    ),
                  if (state.randomMeal?.meals.isNotNullOrEmpty ?? false)
                    const RandomMeal()
                  else
                    const RandomMealShimmer(),
                  const _AlignedText(text: ProjectTexts.userRecipes),
                  const StreamUserRecipes(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class CategoryMealCard extends StatefulWidget {
  const CategoryMealCard({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  State<CategoryMealCard> createState() => _CategoryMealCardState();
}

class _CategoryMealCardState extends State<CategoryMealCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.27),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.pushNamed(
                'details',
                params: {
                  'name': widget.data?.strMeal ?? '',
                  'image': widget.data?.strMealThumb ?? '',
                  'id': widget.data?.idMeal ?? '',
                },
              );
            },
            child: Stack(
              children: <Widget>[
                Align(child: MealName(data: widget.data)),
                CircleMealImage(data: widget.data),
                const Align(
                  alignment: Alignment(0, 0.9),
                  // child: FutureBuilder(
                  //   future: ProjectWidgets.getRatings(
                  //     index,
                  //     ratings,
                  //     context,
                  //     widget.data?.idMeal ?? '',
                  //   ),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return snapshot.data ?? const SizedBox.shrink();
                  //     }
                  //     return const SizedBox.shrink();
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealName extends StatefulWidget {
  const MealName({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  State<MealName> createState() => _MealNameState();
}

class _MealNameState extends State<MealName> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          width: context.dynamicWidth(0.5),
          height: context.dynamicHeight(0.23),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: context.lowBorderRadius,
            ),
            color: ProjectColors.secondWhite,
            child: Padding(
              padding: ProjectPaddings.textHorizontalLarge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    softWrap: true,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    widget.data?.strMeal ?? '',
                    style: context.textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CircleMealImage extends StatelessWidget {
  const CircleMealImage({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.11),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        color: Colors.transparent,
      ),
      child: ProjectWidgets.circleImage(data?.strMealThumb ?? ''),
    );
  }
}

class RandomMeal extends StatefulWidget {
  const RandomMeal({super.key});

  @override
  State<RandomMeal> createState() => _RandomMealState();
}

class _RandomMealState extends State<RandomMeal> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: ProjectPaddings.cardMedium,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _AlignedText(text: ProjectTexts.randomRecipe),
                  GetNewRandomMealButton(),
                ],
              ),
              const RandomMealCard(),
            ],
          ),
        );
      },
    );
  }
}

class GetNewRandomMealButton extends StatelessWidget {
  const GetNewRandomMealButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<HomeCubit>().getRandomMeal();
      },
      icon: const Icon(Icons.refresh),
    );
  }
}

class RandomMealCard extends StatelessWidget {
  const RandomMealCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          width: context.width,
          height: context.dynamicHeight(0.2),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.randomMeal?.meals?.length ?? 0,
            itemBuilder: (context, index) {
              final data = state.randomMeal?.meals?[index];
              return InkWell(
                onTap: () {
                  context.pushNamed(
                    'details',
                    params: {
                      'id': data?.idMeal ?? '',
                      'name': data?.strMeal ?? '',
                      'image': data?.strMealThumb ?? '',
                    },
                  );
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Card(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    child: Row(
                      children: [
                        RandomMealImage(data: data),
                        Stack(
                          children: [
                            Align(
                              alignment: const Alignment(0, -0.8),
                              child: RandomMealName(data: data),
                            ),
                            Align(
                              alignment: const Alignment(0, 0.8),
                              child: FutureBuilder(
                                future: ProjectWidgets.getRatings(
                                  index,
                                  ratings,
                                  context,
                                  data?.idMeal ?? '',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: ProjectPaddings.textHorizontalMedium,
                                      child: snapshot.data ?? const SizedBox.shrink(),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class RandomMealImage extends StatelessWidget {
  const RandomMealImage({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.40,
      child: CachedNetworkImage(
        imageUrl: data?.strMealThumb ?? '',
        fit: BoxFit.fill,
      ),
    );
  }
}

class RandomMealName extends StatelessWidget {
  const RandomMealName({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.textHorizontalMedium,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.40,
        child: Text(
          overflow: TextOverflow.visible,
          data?.strMeal ?? '',
        ),
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  final auth = _auth;
  final userName = auth.currentUser?.displayName?.split(' ')[0];
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
    title: Padding(
      padding: ProjectPaddings.pageMedium,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${ProjectTexts.helloText} $userName \n',
                  style: Theme.of(context).textTheme.headline4,
                ),
                TextSpan(
                  text: ProjectTexts.questionText,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      InkWell(
        onTap: () {
          _key.currentState?.openEndDrawer();
        },
        child: Padding(
          padding: context.horizontalPaddingLow,
          child: const CircleAvatar(
            backgroundColor: ProjectColors.black,
            child: Icon(Icons.person),
          ),
        ),
      ),
    ],
  );
}

class StreamUserRecipes extends StatefulWidget {
  const StreamUserRecipes({
    super.key,
  });

  @override
  State<StreamUserRecipes> createState() => _StreamUserRecipesState();
}

class _StreamUserRecipesState extends State<StreamUserRecipes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('recipes').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final data = snapshot.data?.docs;
        if (data.isNullOrEmpty) {
          return SizedBox(
            height: context.dynamicHeight(0.2),
            child: const Card(
              elevation: 2,
              child: Center(child: Text(ProjectTexts.noRecipeShared)),
            ),
          );
        } else {
          if (snapshot.hasData) {
            return UserRecipeList(data: data);
          }
          return Center(
            child: CustomLottieLoading(
              onLoaded: (controller) {},
            ),
          );
        }
      },
    );
  }
}

class UserRecipeList extends StatelessWidget {
  const UserRecipeList({
    super.key,
    required this.data,
  });

  final List<QueryDocumentSnapshot<Object?>>? data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.25),
      width: context.dynamicWidth(1),
      child: ListView.builder(
        itemCount: data?.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              context.pushNamed(
                'details',
                params: {
                  'name': "${data?[index]['strMeal']}",
                  'image': "${data?[index]['strMealThumb']}",
                  'id': "${data?[index]['idMeal']}",
                },
              );
            },
            child: UserRecipeCard(data: data, index: index),
          );
        },
      ),
    );
  }
}

class UserRecipeCard extends StatelessWidget {
  const UserRecipeCard({
    super.key,
    required this.data,
    required this.index,
  });

  final List<QueryDocumentSnapshot<Object?>>? data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: context.dynamicHeight(0.16),
            width: context.dynamicWidth(0.4),
            child: Image.network(
              fit: BoxFit.cover,
              "${data?[index]['strMealThumb']}",
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.7),
            child: Padding(
              padding: ProjectPaddings.textVerticalMedium,
              child: Text(
                '${data?[index]['strMeal']}\n',
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: FutureBuilder(
              future: ProjectWidgets.getRatings(
                index,
                ratings,
                context,
                '${data?[index]['idMeal']}',
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    required FirebaseAuth auth,
  }) : _auth = auth;

  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: ProjectColors.yellow,
            ),
            child: Text(
              _auth.currentUser?.displayName ?? 'User',
              style: context.textTheme.headline1,
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await _auth.signOut();
              GoRouter.of(context).goNamed('login');
            },
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final ISearchService _searchService;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _searchService = SearchService(Dio(BaseOptions(baseUrl: EndPoints.baseUrl)));
    super.initState();
  }

  CancelableOperation<void>? _operation;

  Future<List<Meals>> search(String key) async {
    await _operation?.cancel();
    _operation = CancelableOperation.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 500),
      ),
    );
    var meals = <Meals>[];
    await _operation?.value.whenComplete(() async {
      meals = await _searchService.searchMeals(key.toCapitalized());
    });

    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: ProjectPaddings.cardMedium,
          // It can't show as starts with
          child: RawAutocomplete<Meals>(
            textEditingController: _controller,
            focusNode: FocusNode(),
            onSelected: (value) {
              context.pushNamed(
                'details',
                params: {
                  'name': value.strMeal ?? '',
                  'image': value.strMealThumb ?? '',
                  'id': value.idMeal ?? '',
                },
              );
              _controller.clear();
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
                        padding: ProjectPaddings.textHorizontalMedium,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final meals = options.elementAt(index);
                          return ListTile(
                            onTap: () async {
                              onSelected(meals);
                            },
                            title: Text(meals.strMeal ?? ''),
                            leading: CachedNetworkImage(
                              imageUrl: meals.strMealThumb ?? '',
                              height: context.dynamicHeight(0.08),
                              width: context.dynamicWidth(0.08),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            displayStringForOption: (option) => option.strMeal ?? '',
            optionsBuilder: (TextEditingValue textEditingValue) async {
              return textEditingValue.text.isEmpty
                  ? []
                  : await search(textEditingValue.text);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
                decoration: InputDecoration(
                  fillColor: ProjectColors.white,
                  suffixIcon: const InkWell(
                    focusColor: ProjectColors.yellow,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      color: ProjectColors.yellow,
                      child: Icon(Icons.search),
                    ),
                  ),
                  hintText: ProjectTexts.searchText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _GetRandomRecipe extends StatelessWidget {
  const _GetRandomRecipe({
    required Future<Meal?> random,
  }) : _random = random;

  final Future<Meal?> _random;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meal?>(
      future: _random,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const RandomMealShimmer();
        }
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data?.meals?.length,
              itemBuilder: (context, index) {
                final data = snapshot.data?.meals?[index];
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      'details',
                      params: {
                        'id': data?.idMeal ?? '',
                        'name': data?.strMeal ?? '',
                        'image': data?.strMealThumb ?? '',
                      },
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: CachedNetworkImage(
                              imageUrl: data?.strMealThumb ?? '',
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: ProjectPaddings.textHorizontalMedium,
                              child: Text(
                                softWrap: true,
                                data?.strMeal ?? '',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const RandomMealShimmer();
        }
      },
    );
  }
}
