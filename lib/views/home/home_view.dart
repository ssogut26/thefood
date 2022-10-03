import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // late Future<Meals?> _meals;

  @override
  void initState() {
    super.initState();
    _categories = NetworkManager.instance.getCategories();
    _areas = NetworkManager.instance.getAreas();
    _ingredients = NetworkManager.instance.getIngredients();
    // _meals = NetworkManager.instance.getMeals('Beef');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: ProjectPaddings().pageMedium,
          child: Column(
            children: [
              _categoriesList(_categories),
              _areaList(_areas),
              _ingredientsList(_ingredients),
            ],
          ),
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
