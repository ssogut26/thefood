import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  late Box<Meals> favoriteBox;
  final List _mealList = <Meal>[];
  List get mealList => _mealList;

  @override
  void initState() {
    favoriteBox = Hive.box('Favorites');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Padding(
        padding: ProjectPaddings.pageMedium,
        child: ValueListenableBuilder<Box<Meals>>(
          valueListenable: favoriteBox.listenable(),
          builder: (context, box, widget) {
            if (box.isEmpty) {
              return const Center(
                child: Text('No Favorites yet'),
              );
            }
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: favoriteBox.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: ProjectPaddings.cardMedium,
                    child: InkWell(
                      onTap: () {
                        context.pushNamed(
                          'details',
                          params: {
                            'id': favoriteBox.getAt(index)?.idMeal ?? '',
                            'name': favoriteBox.getAt(index)?.strMeal ?? '',
                            'image': favoriteBox.getAt(index)?.strMealThumb ?? '',
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
                                  imageUrl: favoriteBox.getAt(index)?.strMealThumb ?? '',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: ProjectPaddings.textMedium,
                                  child: Text(
                                    softWrap: true,
                                    favoriteBox.getAt(index)?.strMeal ?? '',
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  favoriteBox.deleteAt(index);
                                },
                                icon: const Icon(Icons.delete_outline_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
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
