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
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/views/home/cubit/bloc/home_cubit.dart';

part '../../view_models/home_shimmers_view_model.dart';
part '../../view_models/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    dataLenght = 0;
    selectedIndex = 0;
    itemLength();
    isLoading = changeLoading();
    super.initState();
  }

  bool isLoading = true;

  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const _SearchBar(),
                                  if (context.read<HomeCubit>().fetchCategoryData() !=
                                      null)
                                    const ChangeCategory()
                                  else
                                    const CategoryShimmer(),
                                  if (context.read<HomeCubit>().fetchCategoryMealData() !=
                                      null)
                                    const CategoryMeals()
                                  else
                                    const CategoryMealShimmer(
                                      itemCount: 4,
                                    ),
                                  if (context.read<HomeCubit>().fetchRandomMealData() !=
                                      null)
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
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Image.asset(AssetsPath.noConnectionImage)),
                          const Text(
                            ProjectTexts.noConnection,
                          ),
                        ],
                      );
          },
          child: const Scaffold(
            body: Center(
              child: Text(ProjectTexts.offline),
            ),
          ),
        );
      },
    );
  }
}