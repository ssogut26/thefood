import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/area.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';

part 'area_list.dart';
part 'category_list.dart';
part 'ingredients_list.dart';
part 'widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<MealCategory>?> _categories;
  late Future<Area?> _areas;
  late Future<Ingredients?> _ingredients;
  late Future<Meal?> _random;

  @override
  void initState() {
    super.initState();
    _categories = NetworkManager.instance.getCategories();
    _areas = NetworkManager.instance.getAreas();
    _ingredients = NetworkManager.instance.getIngredients();
    _random = NetworkManager.instance.getRandomMeal();
    // _meals = NetworkManager.instance.getMeals('Beef');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ProjectPaddings().pageMedium,
            child: Column(
              children: [
                Row(
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
                _categoriesList(_categories),
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
                                'detail',
                                params: {
                                  'id': data?.idMeal ?? '',
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
                _ingredientsList(_ingredients),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: RichText(
        text: const TextSpan(
          children: <TextSpan>[
            TextSpan(text: 'Hello will name\n'),
            TextSpan(
              text: 'Ready To Cook?',
            ),
          ],
        ),
      ),
      actions: const [
        CircleAvatar(),
      ],
    );
  }
}
