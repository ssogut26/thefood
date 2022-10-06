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
  late Future<Area?> _areas;
  late final Future<Meal?> _categoryMeals;
  late Future<Meal?> _random;

  @override
  void initState() {
    super.initState();
    _categories = NetworkManager.instance.getCategories();
    _areas = NetworkManager.instance.getAreas();
    _random = NetworkManager.instance.getRandomMeal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
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
                            height: 64,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                final data2 = snapshot.data?[index];
                                return Card(
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(
                                            'category',
                                            params: {
                                              'name': _category(data2)?.strCategory ?? '',
                                              'image': data2?.strCategoryThumb ?? '',
                                            },
                                          );
                                        },
                                        child: Card(
                                          color: ProjectColors.mainWhite,
                                          child: Image.network(
                                            data2?.strCategoryThumb ?? '',
                                            height: 32,
                                            width: 32,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        data2?.strCategory ?? '',
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          FutureBuilder(
                            future: NetworkManager.instance.getMealsByCategory(
                              snapshot.data?.map((e) => e.strCategory).toList().first ??
                                  '',
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: 450,
                                  width: MediaQuery.of(context).size.width,
                                  child: GridView.builder(
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent:
                                          MediaQuery.of(context).size.width / 1.5,
                                      mainAxisExtent:
                                          MediaQuery.of(context).size.height / 4,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      final data = snapshot.data?.meals?[index];
                                      return Card(
                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Container(
                                                width: 200,
                                                height: 160,
                                                margin: const EdgeInsets.all(16),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(20),
                                                  ),
                                                  color: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(18),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          data?.strMeal ?? '',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline5,
                                                        ),
                                                      ],
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
                                                    data?.strMealThumb ?? '',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                const _AlignedText(text: 'Random Recipe'),
                FutureBuilder<Meal?>(
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                _areaList(_areas),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MealCategory? _category(MealCategory? data2) => data2;

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
