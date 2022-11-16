import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/compoments/models/meals.dart';
import 'package:thefood/features/compoments/views/home/cubit/bloc/home_cubit.dart';

part 'shimmers.dart';
part 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  @override
  void initState() {
    isLoading = changeLoading();
    dataLenght = 0;
    selectedIndex = 0;
    itemLength();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final connected = connectivity != ConnectivityResult.none;
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : connected
                ? Scaffold(
                    key: _key,
                    appBar: _appBar(context),
                    endDrawer: _Drawer(auth: _auth),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: ProjectPaddings.pageLarge,
                          child: BlocBuilder<HomeCubit, HomeState>(
                            builder: (context, state) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const _SearchBar(),
                                  if (context.read<HomeCubit>().fetchCategoryData() !=
                                      null)
                                    _getCategories(context)
                                  else
                                    const CategoryShimmer(),
                                  if (context.read<HomeCubit>().fetchCategoryMealData() !=
                                      null)
                                    _categoryMeals()
                                  else
                                    const CategoryMealShimmer(
                                      itemCount: 4,
                                    ),
                                  if (context.read<HomeCubit>().fetchRandomMealData() !=
                                      null)
                                    _randomRecipe()
                                  else
                                    const RandomMealShimmer(),
                                  const _AlignedText(text: 'User Recipes'),
                                  const StreamUserRecipes(),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Image.asset('assets/images/no_connection.png')),
                      const Text(
                        'No internet connection',
                      ),
                    ],
                  );
      },
      child: const Scaffold(
        body: Center(
          child: Text('You are offline'),
        ),
      ),
    );
  }
}
