import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  late Box<Meal> favoriteBox;

  @override
  void initState() {
    favoriteBox = Hive.box(ProjectTexts.favoriteBoxName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ProjectTexts.favoriteBoxName),
      ),
      body: Padding(
        padding: ProjectPaddings.pageMedium,
        child: ValueListenableBuilder<Box<Meal>>(
          valueListenable: favoriteBox.listenable(),
          builder: (context, box, widget) {
            if (box.isEmpty) {
              return const Center(
                child: Text(ProjectTexts.noFavoritesYet),
              );
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: favoriteBox.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final meal = favoriteBox.getAt(index)?.meals;
                  final deleteIndex = index;
                  return Padding(
                    padding: ProjectPaddings.cardMedium,
                    child: GoToDetails(
                      meal: meal,
                      favoriteBox: favoriteBox,
                      deleteIndex: deleteIndex,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class GoToDetails extends StatelessWidget {
  const GoToDetails({
    super.key,
    required this.meal,
    required this.favoriteBox,
    required this.deleteIndex,
  });

  final List<Meals>? meal;
  final Box<Meal> favoriteBox;
  final int deleteIndex;

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
  });

  final List<Meals>? meal;
  final Box<Meal> favoriteBox;
  final int deleteIndex;

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
              favoriteBox: favoriteBox,
              deleteIndex: deleteIndex,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.favoriteBox,
    required this.deleteIndex,
  });

  final Box<Meal> favoriteBox;
  final int deleteIndex;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        favoriteBox.deleteAt(deleteIndex);
      },
      icon: const Icon(Icons.delete_outline_outlined),
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
