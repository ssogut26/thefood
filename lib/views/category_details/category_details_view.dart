import 'package:flutter/material.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.image,
    super.key,
    required this.name,
  });
  final String? image;
  final String name;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final manager = NetworkManager.instance;

  late final Future<Meal?> _areaMeals;
  late final Future<Meal?> _ingredientMeals;
  late final Future<Meal?> _categoryMeals;
  late final String _name;
  @override
  void initState() {
    _name = widget.name;
    // _areaMeals = manager.getMealsByArea(_name);
    // _ingredientMeals = manager.getMealsByCategories(_name);
    _categoryMeals = manager.getMeals(_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: ProjectPaddings().pageMedium,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                widget.image ?? '',
                width: 100,
                height: 100,
              ),
              Text('Here is the recipies for ${widget.name}'),
              FutureBuilder<Meal?>(
                future: _categoryMeals,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      physics: const ScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.meals?.length,
                      itemBuilder: (context, index) {
                        final main = snapshot.data?.meals?[index];
                        return Column(
                          children: [
                            Image.network(
                              height: 100,
                              width: 100,
                              main?.strMealThumb ?? '',
                            ),
                            Text(
                              main?.strMeal ?? '',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              // FutureBuilder<Meal?>(
              //   future: _ingredientMeals,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return GridView.builder(
              //         physics: const ScrollPhysics(),
              //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //           maxCrossAxisExtent: 200,
              //         ),
              //         shrinkWrap: true,
              //         itemCount: snapshot.data?.meals?.length,
              //         itemBuilder: (context, index) {
              //           final main = snapshot.data?.meals?[index];
              //           return Column(
              //             children: [
              //               Image.network(
              //                 height: 100,
              //                 width: 100,
              //                 main?.strMealThumb ?? '',
              //               ),
              //               Text(main?.strMeal ?? ''),
              //             ],
              //           );
              //         },
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text(snapshot.error.toString());
              //     } else {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //   },
              // ),
              // FutureBuilder<Meal?>(
              //   future: _categoryMeals,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return GridView.builder(
              //         physics: const ScrollPhysics(),
              //         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //           maxCrossAxisExtent: 200,
              //         ),
              //         shrinkWrap: true,
              //         itemCount: snapshot.data?.meals?.length,
              //         itemBuilder: (context, index) {
              //           final main = snapshot.data?.meals?[index];
              //           return Column(
              //             children: [
              //               Image.network(
              //                 height: 100,
              //                 width: 100,
              //                 main?.strMealThumb ?? '',
              //               ),
              //               Text(main?.strMeal ?? ''),
              //             ],
              //           );
              //         },
              //       );
              //     } else if (snapshot.hasError) {
              //       return Text(snapshot.error.toString());
              //     } else {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
