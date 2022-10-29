import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/home_service.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/views/home/shimmers.dart';

part 'category_list.dart';
part 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    categoryName = 'Beef';
    dataLenght = 0;
    selectedIndex = 0;
    itemLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(HomeService(NetworkManager.instance)),
      child: Scaffold(
        key: _key,
        appBar: _appBar(),
        endDrawer: _Drawer(auth: _auth),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: ProjectPaddings.pageLarge,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      const _SearchBar(),
                      if (context.read<HomeCubit>().fetchCategoryData() != null)
                        _getCategories(context)
                      else
                        const CategoryShimmer(),
                      if (context.read<HomeCubit>().fetchCategoryMealData() != null)
                        _categoryMeals()
                      else
                        const CategoryMealShimmer(
                          itemCount: 4,
                        ),
                      if (context.read<HomeCubit>().fetchRandomMealData() != null)
                        _randomRecipe()
                      else
                        const RandomMealShimmer(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
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
                                padding: ProjectPaddings.textSmall,
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
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
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
      },
    );
  }

  AppBar _appBar() {
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
