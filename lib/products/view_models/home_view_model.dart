part of '../views/home/home_view.dart';

late int selectedIndex;
late int dataLenght;
late String categoryName;
int itemLength() {
  if (dataLenght < 4) {
    return dataLenght;
  }
  return 4;
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        dataLenght = state.mealsByCategory?.meals?.length ?? 0;
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
            return Column(
              children: [
                CategoryMealCard(data: data),
              ],
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

class CategoryMealCard extends StatelessWidget {
  const CategoryMealCard({
    super.key,
    required this.data,
  });

  final Meals? data;

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
                  'name': data?.strMeal ?? '',
                  'image': data?.strMealThumb ?? '',
                  'id': data?.idMeal ?? '',
                },
              );
            },
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                MealName(data: data),
                CircleMealImage(data: data),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MealName extends StatelessWidget {
  const MealName({
    super.key,
    required this.data,
  });

  final Meals? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardImagePaddingSmall,
      child: SizedBox(
        width: context.dynamicWidth(0.5),
        height: context.dynamicHeight(0.23),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: context.lowBorderRadius,
          ),
          color: ProjectColors.secondWhite,
          child: Padding(
            padding: ProjectPaddings.cardImagePadding,
            child: Text(
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              data?.strMeal ?? '',
              style: context.textTheme.bodyText2,
            ),
          ),
        ),
      ),
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
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            data?.strMealThumb ?? '',
          ),
        ),
      ),
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
              const RandomMealcard(),
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

class RandomMealcard extends StatelessWidget {
  const RandomMealcard({
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
                        RandomMealName(data: data),
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
    return Flexible(
      child: Padding(
        padding: ProjectPaddings.textHorizontalMedium,
        child: Text(
          softWrap: true,
          data?.strMeal ?? '',
          style: Theme.of(context).textTheme.bodyText2,
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

class StreamUserRecipes extends StatelessWidget {
  const StreamUserRecipes({
    super.key,
  });

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
          return const Center(
            child: CircularProgressIndicator(),
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
      height: context.dynamicHeight(0.2),
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
      child: Column(
        children: [
          // SizedBox(
          //   height: context.dynamicHeight(0.12),
          //   width: context.dynamicWidth(0.4),
          //   child: Image.network(
          //     fit: BoxFit.cover,
          //     "${data?[index]['strMealThumb']}",
          //   ),
          // ),
          Padding(
            padding: ProjectPaddings.textVerticalMedium,
            child: Column(
              children: [
                Center(
                  child: Text(
                    '${data?[index]['strMeal']}\n',
                  ),
                ),
              ],
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
              color: Colors.blue,
            ),
            child: Text(
              _auth.currentUser?.displayName ?? 'User',
              style: context.textTheme.headline6,
            ),
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              _auth.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Padding(
          padding: ProjectPaddings.cardMedium,
          child: TextFormField(
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
