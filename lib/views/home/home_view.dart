import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/area.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';

part 'area_list.dart';
part 'category_list.dart';
part 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<MealCategory>?> _categories;
  late Future<Meal?> categoryMeals1;
  late Future<Area?> _areas;

  late Future<Meal?> _random;
  late int selectedIndex;
  late String categoryName;
  late int dataLenght;

  int itemLenght() {
    if (dataLenght < 4) {
      return dataLenght;
    }
    return 4;
  }

  bool isLoading = false;

  changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    dataLenght = 0;
    itemLenght();
    categoryName = 'Beef';
    categoryMeals1 = NetworkManager.instance.getMealsByCategory(categoryName);
    _categories = NetworkManager.instance.getCategories();
    _areas = NetworkManager.instance.getAreas();
    _random = NetworkManager.instance.getRandomMeal();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: ProjectPaddings.pageMedium,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 327,
                        child: TextFormField(
                          decoration: InputDecoration(
                            fillColor: ProjectColors.white,
                            suffixIcon: const InkWell(
                              focusColor: ProjectColors.yellow,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                color: ProjectColors.yellow,
                                child: Icon(Icons.search),
                              ),
                            ),
                            hintText: 'Find recipe',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      FutureBuilder<List<MealCategory>?>(
                        future: _categories,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (context, index) {
                                      final data2 = snapshot.data?[index];
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              changeLoading();
                                              selectedIndex = index;
                                              final newCategory = NetworkManager.instance
                                                  .getMealsByCategory(
                                                data2?.strCategory ?? '',
                                              );
                                              setState(() {
                                                categoryMeals1 = newCategory;
                                              });
                                            },
                                            child: Card(
                                              color: selectedIndex == index
                                                  ? ProjectColors.yellow
                                                  : ProjectColors.white,
                                              child: Row(
                                                children: [
                                                  Card(
                                                    color: ProjectColors.mainWhite,
                                                    child: Image.network(
                                                      data2?.strCategoryThumb ?? '',
                                                      height: 32,
                                                      width: 32,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: ProjectPaddings.textSmall,
                                                    child: Text(
                                                      data2?.strCategory ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Recommended'),
                                      TextButton(
                                        child: Text(
                                          'See all',
                                          style: Theme.of(context).textTheme.headline5,
                                        ),
                                        onPressed: () {
                                          context.pushNamed(
                                            'category',
                                            params: {
                                              'name': snapshot.data!
                                                      .elementAt(selectedIndex)
                                                      .strCategory ??
                                                  '',
                                              'image': snapshot.data!
                                                      .elementAt(selectedIndex)
                                                      .strCategoryThumb ??
                                                  '',
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                FutureBuilder<Meal?>(
                                  future: categoryMeals1,
                                  builder: (context, snapshot) {
                                    dataLenght = snapshot.data?.meals?.length ?? 0;
                                    if (snapshot.hasData) {
                                      return GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              MediaQuery.of(context).size.width * 0.5,
                                          mainAxisExtent:
                                              MediaQuery.of(context).size.height * 0.25,
                                        ),
                                        shrinkWrap: true,
                                        itemCount: itemLenght(),
                                        itemBuilder: (context, index) {
                                          final main = snapshot.data?.meals?[index];
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 207,
                                                width:
                                                    MediaQuery.of(context).size.width / 2,
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        context.pushNamed(
                                                          'details',
                                                          params: {
                                                            'name': main?.strMeal ?? '',
                                                            'image':
                                                                main?.strMealThumb ?? '',
                                                            'id': main?.idMeal ?? '',
                                                          },
                                                        );
                                                      },
                                                      child: Stack(
                                                        alignment: Alignment.topCenter,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                              top: 30,
                                                            ),
                                                            child: SizedBox(
                                                              width: 150,
                                                              height: 170,
                                                              child: Card(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(20),
                                                                ),
                                                                color: Colors.white,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 75,
                                                                    left: 15,
                                                                    right: 15,
                                                                  ),
                                                                  child: Text(
                                                                    main?.strMeal ?? '',
                                                                    style:
                                                                        Theme.of(context)
                                                                            .textTheme
                                                                            .bodyText2,
                                                                    textScaleFactor: 0.95,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 90,
                                                            width: 90,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.black12,
                                                              ),
                                                              color: Colors.transparent,
                                                              image: DecorationImage(
                                                                fit: BoxFit.cover,
                                                                image: NetworkImage(
                                                                  main?.strMealThumb ??
                                                                      '',
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _AlignedText(text: 'Random Recipe'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                changeLoading();
                                _random = NetworkManager.instance.getRandomMeal();
                                changeLoading();
                              });
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      _GetRandomRecipe(random: _random),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'Hello will name\n',
                  style: Theme.of(context).textTheme.headline4,
                ),
                TextSpan(
                  text: 'Ready To Cook?',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ],
            ),
          ),
          const CircleAvatar(),
        ],
      ),
    );
  }
}

class _GetRandomRecipe extends StatelessWidget {
  const _GetRandomRecipe({
    required Future<Meal?> random,
  }) : _random = random;

  final Future<Meal?> _random;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Meal?>(
      future: _random,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data?.meals?.length,
            itemBuilder: (context, index) {
              final data = snapshot.data?.meals?[index];
              return InkWell(
                onTap: () {
                  context.pushNamed(
                    'details',
                    params: {
                      'id': data?.idMeal ?? '',
                      'name': data?.strMeal ?? '',
                      'image': data?.strMealThumb ?? '',
                    },
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        data?.strMealThumb ?? '',
                        height: 100,
                        width: 100,
                      ),
                      Text(
                        data?.strMeal ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

// class CategoryPreview extends StatefulWidget {
//   CategoryPreview({
//     super.key,
//     required this.selectedIndex,
//     required this.categoryName,
//   });
//   final AsyncMemoizer<Meal?> _memoizer = AsyncMemoizer();
//   final int selectedIndex;
//   final List<MealCategory?>? categoryName;

//   @override
//   State<CategoryPreview> createState() => _CategoryPreviewState();
// }

// class _CategoryPreviewState extends State<CategoryPreview> {
//   int? itemCount() {
//     if (4 > widget.categoryName![widget.selectedIndex]!.strCategory!.length) {
//       widget.categoryName![widget.selectedIndex]!.strCategory!.length;
//     } else {
//       return 4;
//     }
//     return null;
//   }

//   @override
//   void didUpdateWidget(covariant CategoryPreview oldWidget) {
//     if (oldWidget.categoryName != widget.categoryName &&
//         oldWidget.selectedIndex != widget.selectedIndex) {
//       setState(() {});
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void initState() {
//     categoryMeals;
//     // getCategoryMeals();
//     // getData();
//     super.initState();
//   }

//   // Future<Meal?> getCategoryMeals() {
//   //   return widget._memoizer.runOnce(() async* {
//   //     yield NetworkManager.instance.getMealsByCategory(
//   //       widget.categoryName![widget.selectedIndex]!.strCategory!,
//   //     );
//   //   });
//   // }

//   // Future<Meal?> getData({bool reload = false}) async* {
//   //   if (reload) widget._memoizer = AsyncMemoizer();
//   //   await widget._memoizer.runOnce(getCategoryMeals);
//   //   yield null;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Meal?>(
//       future: categoryMeals,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasData) {
//             return SizedBox(
//               height: 450,
//               width: MediaQuery.of(context).size.width,
//               child: GridView.builder(
//                 physics: const ScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: MediaQuery.of(context).size.width / 1.5,
//                   mainAxisExtent: MediaQuery.of(context).size.height / 4,
//                 ),
//                 shrinkWrap: true,
//                 itemCount: 4,
//                 itemBuilder: (context, index) {
//                   final data = snapshot.data?.meals?[index];
//                   return Card(
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 20),
//                           child: Container(
//                             width: 200,
//                             height: 160,
//                             margin: const EdgeInsets.all(16),
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               color: Colors.white,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(18),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Text(
//                                       data?.strMeal ?? '',
//                                       style: Theme.of(context).textTheme.headline5,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: 90,
//                           width: 90,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.black12,
//                             ),
//                             color: Colors.transparent,
//                             image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                 data?.strMealThumb ?? '',
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         }
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }
// }
