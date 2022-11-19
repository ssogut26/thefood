import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/services/category_meal_service.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/views/category_details/cubit/category_details_cubit.dart';
import 'package:thefood/products/views/home/home_view.dart';

class CategoryDetailsView extends StatefulWidget {
  const CategoryDetailsView({
    this.image,
    super.key,
    required this.name,
  });
  final String? image;
  final String name;
  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<CategoryDetailsView> {
  final manager = NetworkManager.instance;
  late final Future<Meal?> _categoryMeals;
  late final String _name;
  @override
  void initState() {
    _name = widget.name;
    _categoryMeals = manager.getMealsByCategory(_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDetailsCubit(CategoryMealService(NetworkManager.instance)),
      child: Scaffold(
        appBar: _appbar(context),
        body: Padding(
          padding: ProjectPaddings.pageLarge,
          child: BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<Meal?>(
                      future:
                          context.read<CategoryDetailsCubit>().getMealsByCategory(_name),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListCategoryMeals(
                            meal: snapshot.data,
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else {
                          return const CategoryMealShimmer(
                            itemCount: 8,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      toolbarHeight: context.dynamicHeight(0.08),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ProjectColors.lightGrey,
              ProjectColors.yellow,
            ],
          ),
        ),
      ),
      title: Text(_name),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ListCategoryMeals extends StatelessWidget {
  const ListCategoryMeals({
    super.key,
    required this.meal,
  });

  final Meal? meal;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
        mainAxisExtent: MediaQuery.of(context).size.height / 3.5,
      ),
      shrinkWrap: true,
      itemCount: meal?.meals?.length,
      itemBuilder: (context, index) {
        final main = meal?.meals?[index];
        return CategoryMealCard(main: main);
      },
    );
  }
}

class CategoryMealCard extends StatelessWidget {
  const CategoryMealCard({
    super.key,
    required this.main,
  });

  final Meals? main;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.28),
      width: MediaQuery.of(context).size.width / 2,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          context.pushNamed(
            'details',
            params: {
              'name': main?.strMeal ?? '',
              'image': main?.strMealThumb ?? '',
              'id': main?.idMeal ?? '',
            },
          );
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            MealName(main: main),
            CircleMealImage(main: main),
          ],
        ),
      ),
    );
  }
}

class MealName extends StatelessWidget {
  const MealName({
    super.key,
    required this.main,
  });

  final Meals? main;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardImagePaddingSmall,
      child: SizedBox(
        width: context.dynamicWidth(0.42),
        height: context.dynamicHeight(0.23),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: context.lowBorderRadius,
          ),
          color: ProjectColors.lightGrey,
          child: Padding(
            padding: ProjectPaddings.cardImagePadding,
            child: Text(
              main?.strMeal ?? '',
              style: context.textTheme.bodyText2,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleMealImage extends StatelessWidget {
  const CircleMealImage({
    super.key,
    required this.main,
  });

  final Meals? main;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.dynamicHeight(0.12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            main?.strMealThumb ?? '',
          ),
        ),
      ),
    );
  }
}
