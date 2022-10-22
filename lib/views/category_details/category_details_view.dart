import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/views/home/shimmers.dart';

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
    return Scaffold(
      appBar: _appbar(context),
      body: Padding(
        padding: ProjectPaddings.pageMedium,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopCategory(
                widget: widget,
              ),
              const SizedBox(height: 20),
              _getMeals(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<Meal?> _getMeals() {
    return FutureBuilder<Meal?>(
      future: _categoryMeals,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            physics: const ScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
              mainAxisExtent: MediaQuery.of(context).size.height / 3.8,
            ),
            shrinkWrap: true,
            itemCount: snapshot.data?.meals?.length,
            itemBuilder: (context, index) {
              final main = snapshot.data?.meals?[index];
              return Column(
                children: [
                  SizedBox(
                    height: context.dynamicHeight(0.26),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      children: [
                        GestureDetector(
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
                              Padding(
                                padding: ProjectPaddings.cardImagePaddingSmall,
                                child: SizedBox(
                                  width: context.dynamicWidth(0.4),
                                  height: context.dynamicHeight(0.22),
                                  child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: context.lowBorderRadius,
                                    ),
                                    color: ProjectColors.secondWhite,
                                    child: Padding(
                                      padding: ProjectPaddings.cardImagePadding,
                                      child: Text(
                                        main?.strMeal ?? '',
                                        style: context.textTheme.bodyText2,
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
                                  border: Border.all(),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      main?.strMealThumb ?? '',
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
          return const CategoryMealShimmer(
            itemCount: 8,
          );
        }
      },
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
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

class TopCategory extends StatelessWidget {
  const TopCategory({
    required this.widget,
  });

  final CategoryDetailsView widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          CachedNetworkImage(
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageUrl: widget.image ?? '',
            width: 100,
            height: 100,
          ),
          Text(
            '${ProjectTexts.recipiesFor} ${widget.name}',
          ),
        ],
      ),
    );
  }
}
