import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paginable/paginable.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/area.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/models/ingredients.dart';
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

  @override
  void initState() {
    super.initState();
    _categories = NetworkManager.instance.getCategories();
    _areas = NetworkManager.instance.getAreas();
    _ingredients = NetworkManager.instance.getIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: ProjectPaddings().pageMedium,
        child: Column(
          children: [
            _categoriesList(_categories),
            _areaList(_areas),
            FutureBuilder<Ingredients?>(
              future: _ingredients,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: ProjectPaddings().cardMedium,
                    child: Column(
                      children: [
                        const _AlignedText(text: ProjectTexts.ingredients),
                        _CardBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.meals!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data?.meals?[index];
                              return Card(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context.pushNamed(
                                          'details',
                                          params: {
                                            'id': data?.idIngredient ?? '',
                                            'name': data?.strIngredient ?? '',
                                            'image':
                                                '${EndPoints().ingredientsImages}${data?.strIngredient ?? ''}.png',
                                          },
                                        );
                                      },
                                      child: _ImageBox(
                                        url:
                                            '${EndPoints().ingredientsImages}${data?.strIngredient ?? ''}.png',
                                      ),
                                    ),
                                    Text(
                                      data?.strIngredient ?? '',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('theFood'),
    );
  }
}
