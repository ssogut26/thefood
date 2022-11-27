import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/search_service.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/features/components/widgets.dart';
import 'package:thefood/products/models/categories.dart';
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
    dataLength = 0;
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
                ? Center(
                    child: CustomLottieLoading(
                      onLoaded: (composition) {
                        isLoading = false;
                      },
                    ),
                  )
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
                                  if (state.mealCategory.isNotNullOrEmpty)
                                    const ChangeCategory()
                                  else
                                    const CategoryShimmer(),
                                  if (state.mealsByCategory?.meals?.isNotNullOrEmpty ??
                                      false)
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
