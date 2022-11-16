part of 'home_view.dart';

late int selectedIndex;
late int dataLenght;
late String categoryName;
int itemLength() {
  if (dataLenght < 4) {
    return dataLenght;
  }
  return 4;
}

bool isLoading = true;

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

class ConnectivityChecker extends StatefulWidget {
  const ConnectivityChecker({
    super.key,
    required Widget Function(BuildContext, ConnectivityResult, Widget) builder,
  }) : _builder = builder;

  final Widget Function(BuildContext, ConnectivityResult, Widget) _builder;

  @override
  State<ConnectivityChecker> createState() => _ConnectivityCheckerState();
}

class _ConnectivityCheckerState extends State<ConnectivityChecker> {
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: widget._builder,
    );
  }
}

BlocBuilder _getCategories(BuildContext context) {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            height: 50,
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
                    GestureDetector(
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
                        }
                        context.read<HomeCubit>().changeSelectedIndex(index);
                      },
                      child: Card(
                        color: state.selectedIndex == index
                            ? ProjectColors.yellow
                            : ProjectColors.white,
                        child: Row(
                          children: [
                            Card(
                              color: ProjectColors.mainWhite,
                              child: CachedNetworkImage(
                                imageUrl: data.strCategoryThumb ?? '',
                                height: 32,
                                width: 32,
                              ),
                            ),
                            Padding(
                              padding: ProjectPaddings.textHorizontalSmall,
                              child: Text(
                                data.strCategory ?? '',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        'name': state.mealCategory!
                                .elementAt(state.selectedIndex)
                                .strCategory ??
                            '',
                        'image': state.mealCategory!
                                .elementAt(state.selectedIndex)
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

BlocBuilder<HomeCubit, HomeState> _categoryMeals() {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      dataLenght = state.mealsByCategory?.meals?.length ?? 0;
      return GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: context.dynamicWidth(0.05),
          mainAxisSpacing: context.dynamicWidth(0.02),
          maxCrossAxisExtent: context.dynamicWidth(0.5),
          mainAxisExtent: context.dynamicHeight(0.27),
        ),
        shrinkWrap: true,
        itemCount: itemLength(),
        itemBuilder: (context, index) {
          final data = state.mealsByCategory?.meals?[index];
          if (data == null) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              SizedBox(
                height: context.dynamicHeight(0.27),
                child: Column(
                  children: [
                    GestureDetector(
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
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Padding(
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
                                    data.strMeal ?? '',
                                    style: context.textTheme.bodyText2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(),
                              color: Colors.transparent,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  data.strMealThumb ?? '',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

BlocBuilder<HomeCubit, HomeState> _randomRecipe() {
  return BlocBuilder<HomeCubit, HomeState>(
    builder: (context, state) {
      return Padding(
        padding: ProjectPaddings.cardMedium,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _AlignedText(text: 'Random Recipe'),
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().getRandomMeal();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            SizedBox(
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: CachedNetworkImage(
                                imageUrl: data?.strMealThumb ?? '',
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
            ),
          ],
        ),
      );
    },
  );
}

AppBar _appBar(BuildContext context) {
  final auth = _auth;
  final userName = auth.currentUser?.displayName?.split(' ')[0];
  return AppBar(
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
      GestureDetector(
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
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final data = snapshot.data?.docs;
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            height: context.dynamicHeight(0.2),
            width: context.dynamicWidth(1),
            child: UserRecipeList(data: data),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          return const SizedBox.shrink();
        } else {
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
    return ListView.builder(
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
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  height: context.dynamicHeight(0.14),
                  width: context.dynamicWidth(0.4),
                  child: Image.network(
                    fit: BoxFit.cover,
                    "${data?[index]['strMealThumb']}",
                  ),
                ),
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
          ),
        );
      },
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
