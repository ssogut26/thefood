import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/views/favorites/cubit/favorite_cubit.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state.favoriteBox?.isNotEmpty ?? false) {
            context.read<FavoritesCubit>().checkUpdated();
          }
        },
        builder: (context, state) {
          return context.read<FavoritesCubit>().favoriteBox?.isNotEmpty ?? false
              ? Padding(
                  padding: ProjectPaddings.pageMedium,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: context.read<FavoritesCubit>().favoriteBox?.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final meal = state.favoriteBox?[index]?.meals;
                        return Padding(
                          padding: ProjectPaddings.cardMedium,
                          child: InkWell(
                            onTap: () {
                              context.pushNamed(
                                'details',
                                params: {
                                  'id': meal?.map((e) => e.idMeal).toString().substring(
                                            1,
                                            meal.map((e) => e.idMeal).toString().length -
                                                1,
                                          ) ??
                                      '',
                                  'name': meal
                                          ?.map((e) => e.strMeal)
                                          .toString()
                                          .substring(
                                            1,
                                            meal.map((e) => e.strMeal).toString().length -
                                                1,
                                          ) ??
                                      '',
                                  'image': meal
                                          ?.map((e) => e.strMealThumb)
                                          .toString()
                                          .substring(
                                            1,
                                            meal
                                                    .map((e) => e.strMealThumb)
                                                    .toString()
                                                    .length -
                                                1,
                                          ) ??
                                      '',
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
                                        imageUrl: meal
                                                ?.map((e) => e.strMealThumb)
                                                .toString()
                                                .substring(
                                                  1,
                                                  meal
                                                          .map((e) => e.strMealThumb)
                                                          .toString()
                                                          .length -
                                                      1,
                                                ) ??
                                            '',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: ProjectPaddings.textMedium,
                                        child: Text(
                                          softWrap: true,
                                          meal
                                                  ?.map((e) => e.strMeal)
                                                  .toString()
                                                  .substring(
                                                    1,
                                                    meal
                                                            .map((e) => e.strMeal)
                                                            .toString()
                                                            .length -
                                                        1,
                                                  ) ??
                                              '',
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<FavoritesCubit>().removeItem(
                                              meal
                                                      ?.map((e) => e.idMeal)
                                                      .toString()
                                                      .substring(
                                                        1,
                                                        meal
                                                                .map((e) => e.idMeal)
                                                                .toString()
                                                                .length -
                                                            1,
                                                      ) ??
                                                  '',
                                            );
                                      },
                                      // onPressed: () async {
                                      //   await context
                                      //       .read<FavoritesCubit>()
                                      //       .favoriteCacheManager
                                      //       .removeItem(
                                      //         meal
                                      //                 ?.map((e) => e.idMeal)
                                      //                 .toString()
                                      //                 .substring(
                                      //                   1,
                                      //                   meal
                                      //                           .map(
                                      //                             (e) => e.idMeal,
                                      //                           )
                                      //                           .toString()
                                      //                           .length -
                                      //                       1,
                                      //                 ) ??
                                      //             '',
                                      //       );
                                      //   setState(() {});
                                      // },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'No Favorites',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
        },
      ),
    );
  }
}

AppBar _appBar() {
  return AppBar(
    title: const Text(ProjectTexts.favoriteBoxName),
  );
}
