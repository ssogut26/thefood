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
                                child: Image.network(
                                  loadingBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  favoriteBox.getAt(index)?.strMealThumb ?? '',
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
            // ListView.builder(
            //   itemCount: favoriteBox.length,
            //   itemBuilder: (context, index) {
            //     return Row(
            //       children: [
            //         Image.network(
            //           favoriteBox.getAt(index)!.strMealThumb ?? '',
            //           width: 100,
            //           height: 100,
            //           fit: BoxFit.cover,
            //         ),
            //         Text(favoriteBox.getAt(index)?.strMeal ?? ''),
            //         IconButton(
            //           onPressed: () {
            //             favoriteBox.deleteAt(index);
            //           },
            //           icon: const Icon(Icons.delete),
            //         ),
            //       ],
            //     );
            //   },

            // child: ListView.builder(
            //   itemCount: favoriteBox.values.length,
            //   itemBuilder: (context, index) {
            //     return Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         // Image.network(
            //         //   height: 100,
            //         //   width: 100,
            //         //    favoriteBox.getAt(index)?? '',
            //         // ),
            //         Text(favoriteBox.getAt(index) ?? ''),
            //         IconButton(
            //           onPressed: () {
            //             favoriteBox.deleteAt(index);
            //             setState(() {});
            //           },
            //           icon: const Icon(Icons.favorite_outline_outlined),
            //         )
            //       ],
            //     );
            //   },
            // ),
            // );
          },
        ),
      ),
    );
  }
}
