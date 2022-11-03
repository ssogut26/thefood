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
      appBar: _appBar(context),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listenWhen: (previous, current) {
          return previous.favoriteBox?.length != current.favoriteBox?.length;
        },
        listener: (context, state) {
          if (state.favoriteBox?.length !=
              context.read<FavoritesCubit>().favoriteCacheManager.getValues()?.length) {
            context.watch<FavoritesCubit>().fetchListOfFavorites();
          }
        },
        builder: (context, state) {
          return context.watch<FavoritesCubit>().favoriteBox?.isNotEmpty ?? false
              ? RefreshIndicator(
                  onRefresh: context.read<FavoritesCubit>().onRefresh(),
                  child: Padding(
                    padding: ProjectPaddings.pageMedium,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: context.watch<FavoritesCubit>().favoriteBox?.length,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final meal = state.favoriteBox?[index]?.meals;
                          return Padding(
                            padding: ProjectPaddings.cardMedium,
                            child: InkWell(
                              onTap: () {
                                context.pushNamed(
                                  'details',
                                  params: {
                                    'id': meal
                                            ?.map((e) => e.idMeal)
                                            .toString()
                                            .deletePharanteses() ??
                                        '',
                                    'name': meal
                                            ?.map((e) => e.strMeal)
                                            .toString()
                                            .deletePharanteses() ??
                                        '',
                                    'image': meal
                                            ?.map((e) => e.strMealThumb)
                                            .toString()
                                            .deletePharanteses() ??
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
                                                  .deletePharanteses() ??
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
                                                    .deletePharanteses() ??
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
                                                        .deletePharanteses() ??
                                                    '',
                                              );
                                        },
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
                  ),
                )
              : Center(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      await context.read<FavoritesCubit>().fetchListOfFavorites();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 1.2,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${ProjectTexts.noFavoritesYet}\n\n',
                                    style: Theme.of(context).textTheme.headline2,
                                  ),
                                  TextSpan(
                                    text: 'To refresh, pull down',
                                    style:
                                        Theme.of(context).textTheme.bodyText1?.copyWith(
                                              letterSpacing: 0.5,
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    title: Text(
      ProjectTexts.favoriteBoxName,
      style: Theme.of(context).textTheme.headline1,
    ),
  );
}

extension on String {
  String deletePharanteses() {
    return substring(1, length - 1);
  }
}
