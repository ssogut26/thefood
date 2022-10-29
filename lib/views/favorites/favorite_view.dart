import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/cache_manager.dart';
import 'package:thefood/views/favorites/cubit/favorite_cubit.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritesCubit(),
      child: Scaffold(
        appBar: _appBar(),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            return Padding(
              padding: ProjectPaddings.pageMedium,
              child: (context
                          .read<FavoritesCubit>()
                          .favoriteCacheManager
                          .getValues()
                          ?.isNotEmpty ??
                      false)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.favoriteBox?.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final meal = state.favoriteBox?[index]?.meals;
                          final deleteIndex = index;
                          return Padding(
                            padding: ProjectPaddings.cardMedium,
                            child: GoToDetails(
                              meal: meal,
                              favoriteBox: state.favoriteBox,
                              deleteIndex: deleteIndex,
                              favoriteCacheManager:
                                  context.read<FavoritesCubit>().favoriteCacheManager,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(ProjectTexts.noFavoritesYet),
                    ),
            );
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(ProjectTexts.favoriteBoxName),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.favoriteCacheManager,
    required this.meal,
    required this.deleteIndex,
  });

  final ICacheManager<Meal> favoriteCacheManager;
  final List<Meals>? meal;
  final int deleteIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<FavoritesCubit>().removeItem(meal?[deleteIndex].idMeal ?? '');
      },
      icon: const Icon(Icons.delete_outline_outlined),
    );
  }
}

class GoToDetails extends StatelessWidget {
  const GoToDetails({
    super.key,
    required this.meal,
    required this.favoriteBox,
    required this.deleteIndex,
    required this.favoriteCacheManager,
  });

  final List<Meals>? meal;
  final List<Meal?>? favoriteBox;
  final int deleteIndex;
  final ICacheManager<Meal> favoriteCacheManager;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          'details',
          params: {
            'id': meal?.map((e) => e.idMeal).toString().substring(
                      1,
                      meal!.map((e) => e.idMeal).toString().length - 1,
                    ) ??
                '',
            'name': meal?.map((e) => e.strMeal).toString().substring(
                      1,
                      meal!.map((e) => e.strMeal).toString().length - 1,
                    ) ??
                '',
            'image': meal?.map((e) => e.strMealThumb).toString().substring(
                      1,
                      meal!.map((e) => e.strMealThumb).toString().length - 1,
                    ) ??
                '',
          },
        );
      },
      child: CardBox(
        favoriteCacheManager: favoriteCacheManager,
        meal: meal,
        favoriteBox: favoriteBox,
        deleteIndex: deleteIndex,
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  const CardBox({
    super.key,
    required this.meal,
    required this.favoriteBox,
    required this.deleteIndex,
    required this.favoriteCacheManager,
  });

  final List<Meals>? meal;
  final List<Meal?>? favoriteBox;
  final int deleteIndex;
  final ICacheManager<Meal> favoriteCacheManager;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            ImageBox(meal: meal),
            MealText(meal: meal),
            DeleteButton(
              favoriteCacheManager: favoriteCacheManager,
              meal: meal,
              deleteIndex: deleteIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.40,
      child: CachedNetworkImage(
        imageUrl: meal?.map((e) => e.strMealThumb).toString().substring(
                  1,
                  meal!.map((e) => e.strMealThumb).toString().length - 1,
                ) ??
            '',
        fit: BoxFit.fill,
      ),
    );
  }
}

class MealText extends StatelessWidget {
  const MealText({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ProjectPaddings.textMedium,
        child: Text(
          softWrap: true,
          meal?.map((e) => e.strMeal).toString().substring(
                    1,
                    meal!.map((e) => e.strMeal).toString().length - 1,
                  ) ??
              '',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
