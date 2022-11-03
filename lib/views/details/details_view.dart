import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/assets_path.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/cache_manager.dart';
import 'package:thefood/views/details/cubit/details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.image,
    required this.id,
    super.key,
    this.name,
  });
  final String? image;
  final String? name;
  final int id;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Padding(
              padding: ProjectPaddings.cardSmall,
              child: IconButton(
                icon: CircleAvatar(
                  backgroundColor: ProjectColors.actionsBgColor,
                  child: SvgPicture.asset(
                    AssetsPath.back,
                    color: ProjectColors.black,
                  ),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: widget.image ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => BlocBuilder<DetailsCubit, DetailsState>(
                builder: (context, state) {
                  return Padding(
                    padding: context.paddingLow,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: ProjectColors.mainWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: context.lowRadius,
                          topRight: context.lowRadius,
                        ),
                      ),
                      child: Padding(
                        padding: ProjectPaddings.pageLarge,
                        child: state.favoriteMealDetail?.meals?.isNotNullOrEmpty ?? false
                            ? _MealDetails(
                                details: widget,
                                items: state.favoriteMealDetail,
                                favoriteCacheManager:
                                    context.read<DetailsCubit>().favoriteCacheManager,
                              )
                            : _MealDetails(
                                details: widget,
                                items: state.meal,
                                favoriteCacheManager:
                                    context.read<DetailsCubit>().favoriteCacheManager,
                              ),
                      ),
                    ),
                  );
                },
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
      // ),
    );
  }
}

class _MealDetails extends StatefulWidget {
  const _MealDetails({
    required this.details,
    required this.items,
    required this.favoriteCacheManager,
  });

  final DetailsView details;
  final Meal? items;
  final ICacheManager<Meal>? favoriteCacheManager;
  @override
  State<_MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<_MealDetails> {
  late int selectedIndex;
  int index = 0;
  Future<void> launch(Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ProjectTexts.linkError),
        ),
      );
    } else {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: state.favoriteMealDetail?.meals?.length ?? 0,
          itemBuilder: (context, index) {
            final meals = state.favoriteMealDetail?.meals?[index];
            final ingredientList = meals?.getIngredients();
            final measureList = meals?.getMeasures();
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Text(
                            widget.details.name ?? '',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: IconButton(
                            icon: CircleAvatar(
                              backgroundColor: ProjectColors.actionsBgColor,
                              child: SvgPicture.asset(
                                AssetsPath.bookmark,
                                color: ProjectColors.black,
                              ),
                            ),
                            onPressed: () async {
                              context
                                  .read<DetailsCubit>()
                                  .favoriteCacheManager
                                  .getValues();
                              if (context
                                      .read<DetailsCubit>()
                                      .favoriteMealDetail
                                      ?.meals
                                      .isNotNullOrEmpty ??
                                  false) {
                                await context
                                    .read<DetailsCubit>()
                                    .favoriteCacheManager
                                    .putItem(
                                      state.id.toString(),
                                      state.favoriteMealDetail!,
                                    );
                              }
                              // show snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to favorites'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryName(meals: meals),
                        AreaImage(meals: meals),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: TextButton(
                            autofocus: true,
                            onPressed: () async {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              scale: (selectedIndex == 0) ? 1.2 : 1,
                              child: Text(
                                ProjectTexts.ingredients,
                                style: (selectedIndex == 0)
                                    ? Theme.of(context).textTheme.headline3
                                    : Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              scale: (selectedIndex == 1) ? 1.2 : 1,
                              child: Text(
                                ProjectTexts.instructions,
                                style: (selectedIndex == 1)
                                    ? Theme.of(context).textTheme.headline3
                                    : Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (selectedIndex == 0)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int index = 0;
                              index < ingredientList!.length && index.isFinite;
                              index++)
                            ingredientList[index].isNotNullOrNoEmpty
                                ? _ingredients(
                                    ingredientList,
                                    index,
                                    context,
                                    measureList,
                                  )
                                : const SizedBox.shrink(),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meals?.strInstructions ?? ''),
                          TextButton(
                            onPressed: () {
                              launch(
                                Uri.parse(
                                  meals?.strYoutube ?? '',
                                ),
                              );
                            },
                            child: const Text('Watch Video'),
                          ),
                          TextButton(
                            onPressed: () {
                              launch(
                                Uri.parse(
                                  meals?.strSource ?? '',
                                ),
                              );
                            },
                            child: const Text('Source'),
                          ),
                        ],
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  SizedBox _ingredients(
    List<String?> ingredientList,
    int index,
    BuildContext context,
    List<String?>? measureList,
  ) {
    return SizedBox(
      height: 60,
      width: 325,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              color: ProjectColors.lightGrey,
              child: CachedNetworkImage(
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 60,
                height: 60,
                imageUrl:
                    '${EndPoints.ingredientsImages}${ingredientList[index]}-small.png',
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: ProjectPaddings.textLarge,
              child: Text(
                '${ingredientList[index]}'.capitalize(),
                style: Theme.of(context).textTheme.headline3,
              ).toVisible(
                ingredientList[index] != null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text('${measureList?[index]}').toVisible(
              measureList?[index] != null,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryName extends StatelessWidget {
  const CategoryName({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: ProjectPaddings.cardLarge,
        child: Text('in ${meals?.strCategory}').toVisible(
          meals?.strCategory != null,
        ),
      ),
    );
  }
}

class AreaImage extends StatelessWidget {
  const AreaImage({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: CachedNetworkImage(
        imageUrl: countryFlagMap[meals?.strArea] ?? '',
        height: 32,
        width: 32,
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
