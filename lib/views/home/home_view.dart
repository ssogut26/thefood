import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/cache_manager.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/views/home/shimmers.dart';

part 'category_list.dart';
part 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Meal?> categoryMeals;
  late Future<Meal?> _random;
  late int selectedIndex;
  late String categoryName;
  late int dataLenght;
  late StreamSubscription subscription;
  List<MealCategory>? _categoryItems;
  Meal? categoryMealItems;
  Meal? randomMealItems;
  late final ICacheManager<MealCategory> categoryCacheManager;
  late final ICacheManager<Meal> mealCacheManager;
  late final ICacheManager<Meal> randomMealCacheManager;

  Future<void> fetchData() async {
    await categoryCacheManager.init();
    if (categoryCacheManager.getValues()?.isNotEmpty ?? false) {
      _categoryItems = categoryCacheManager.getValues();
    } else {
      _categoryItems = await NetworkManager.instance.getCategories();
    }
    setState(() {});
    await mealCacheManager.init();
    if (mealCacheManager.getItem(categoryName)?.meals?.isNotEmpty ?? false) {
      categoryMealItems = mealCacheManager.getItem(categoryName);
    } else {
      categoryMealItems = await NetworkManager.instance.getMealsByCategory(categoryName);
    }
    setState(() {});

    await randomMealCacheManager.init();
    if (randomMealCacheManager.getItem(EndPoints.randomMeal)?.meals?.isNotEmpty ??
        false) {
      randomMealItems = randomMealCacheManager.getItem(EndPoints.randomMeal);
    } else {
      randomMealItems = await NetworkManager.instance.getRandomMeal();
    }
    setState(() {});
  }

  int itemLength() {
    if (dataLenght < 4) {
      return dataLenght;
    }
    return 4;
  }

  bool isLoading = false;

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    Future.delayed(const Duration(seconds: 10), () {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No internet access. Check your connection'),
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Dissmiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Internet access is available'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                setState(() {
                  _random = NetworkManager.instance.getRandomMeal();
                  categoryMeals =
                      NetworkManager.instance.getMealsByCategory(categoryName);
                });
              },
            ),
          ),
        );
      }
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _auth = FirebaseAuth.instance;
  late int favoritesIndex;
  List<String> favorites = [];
  late bool isFavorite;
  @override
  void initState() {
    subscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      checkConnectivity();
    });
    isFavorite = favorites.isNotEmpty;
    dataLenght = 0;
    itemLength();
    categoryCacheManager = MealCategoryCacheManager('mealCategory');
    mealCacheManager = CategoryMealsCacheManager('categoryMeal');
    randomMealCacheManager = RandomMealCacheManager('randomMeal');
    fetchData();
    categoryName = 'Beef';
    categoryMeals = NetworkManager.instance.getMealsByCategory(categoryName);
    _random = NetworkManager.instance.getRandomMeal();
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: _appBar(),
      endDrawer: Drawer(
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ProjectPaddings.pageLarge,
            child: Column(
              children: [
                const _SearchBar(),
                if (_categoryItems?.isNotEmpty ?? false)
                  _getCategories(context)
                else
                  const CategoryShimmer(),
                if (categoryMealItems?.meals?.isNotEmpty ?? false)
                  _categoryMeals()
                else
                  const CategoryMealShimmer(
                    itemCount: 4,
                  ),
                if (randomMealItems?.meals?.isNotEmpty ?? false)
                  _randomRecipe()
                else
                  const RandomMealShimmer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _getCategories(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _categoryItems?.length,
            itemBuilder: (context, index) {
              final data = _categoryItems?[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      changeLoading();
                      if (mealCacheManager
                              .getItem(data?.strCategory ?? '')
                              ?.meals
                              ?.isNotEmpty ??
                          false) {
                        categoryMealItems =
                            mealCacheManager.getItem(data?.strCategory ?? '');
                      } else {
                        categoryMealItems = await NetworkManager.instance
                            .getMealsByCategory(data?.strCategory ?? '');
                      }
                      selectedIndex = index;
                      setState(() {});
                      changeLoading();
                    },
                    child: Card(
                      color: selectedIndex == index
                          ? ProjectColors.yellow
                          : ProjectColors.white,
                      child: Row(
                        children: [
                          Card(
                            color: ProjectColors.mainWhite,
                            child: CachedNetworkImage(
                              imageUrl: data?.strCategoryThumb ?? '',
                              height: 32,
                              width: 32,
                            ),
                          ),
                          Padding(
                            padding: ProjectPaddings.textSmall,
                            child: Text(
                              data?.strCategory ?? '',
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
                      'name': _categoryItems!.elementAt(selectedIndex).strCategory ?? '',
                      'image':
                          _categoryItems!.elementAt(selectedIndex).strCategoryThumb ?? '',
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  GridView _categoryMeals() {
    dataLenght = categoryMealItems?.meals?.length ?? 0;
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
        final data = categoryMealItems?.meals?[index];
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
                          'name': data?.strMeal ?? '',
                          'image': data?.strMealThumb ?? '',
                          'id': data?.idMeal ?? '',
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
                                  data?.strMeal ?? '',
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
                                data?.strMealThumb ?? '',
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
  }

  Padding _randomRecipe() {
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
                  setState(() {
                    changeLoading();
                    randomMealCacheManager.getValues();
                    changeLoading();
                  });
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: randomMealItems?.meals?.length,
              itemBuilder: (context, index) {
                final data = randomMealItems?.meals?[index];
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
                              padding: ProjectPaddings.textMedium,
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
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          categoryCacheManager.getValues();
          if (_categoryItems?.isNotEmpty ?? false) {
            await categoryCacheManager.addItems(_categoryItems!);
          }
        },
        icon: const Icon(Icons.menu),
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
                    text:
                        '${ProjectTexts.helloText} ${_auth.currentUser?.displayName} \n',
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
            // drawer
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
                              padding: ProjectPaddings.textMedium,
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
