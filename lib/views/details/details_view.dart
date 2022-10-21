import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/assets_path.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/flags.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';
import 'package:url_launcher/url_launcher.dart';

part 'details_view_model.dart';

class DetailsView extends StatefulWidget {
  DetailsView({
    this.image,
    required this.id,
    super.key,
    this.name,
  });
  final String? image;
  final String? name;
  final int id;
  late bool isOnline = false;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late final Future<Meal?> _meals;
  late Box<Meal> favoriteMealBox;
  late StreamSubscription _subscription;

  bool checkIsOnline() {
    checkConnectivity();
    return widget.isOnline;
  }

  Future<void> checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    Future.delayed(const Duration(seconds: 1), () {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet access. Check your connection ${widget.isOnline}'),
            duration: const Duration(seconds: 100),
            action: SnackBarAction(
              label: 'Dissmiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                setState(() {
                  widget.isOnline = false;
                });
              },
            ),
          ),
        );
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        setState(() {
          widget.isOnline = true;
        });
      }
    });
  }

  @override
  void initState() {
    _meals = NetworkManager.instance.getMeal(widget.id);
    favoriteMealBox = Hive.box(ProjectTexts.favoriteBoxName);
    widget.isOnline = checkIsOnline();
    _subscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      checkConnectivity();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _appBar(context),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                SizedBox(
                  child: CachedNetworkImage(
                    imageUrl: widget.image ?? '',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: ProjectColors.mainWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: ProjectPaddings.pageLarge,
                child: widget.isOnline
                    ? FutureBuilder<Meal?>(
                        future: _meals,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _MealDetails(
                              widget: widget,
                              items: snapshot.data,
                            );
                          } else if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const Center(
                              child: Text('Error'),
                            );
                          }
                        },
                      )
                    : ValueListenableBuilder<Box<Meal>>(
                        valueListenable: favoriteMealBox.listenable(),
                        builder: (context, Box<Meal> box, _) {
                          final meals = box.get('${widget.id}');
                          return _MealDetails(
                            widget: widget,
                            items: meals,
                          );
                        },
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: CircleAvatar(
          backgroundColor: ProjectColors.actionsBgColor,
          child: SvgPicture.asset(
            AssetsPath.back,
            color: ProjectColors.black,
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _MealDetails extends StatefulWidget {
  const _MealDetails({
    required this.widget,
    required this.items,
  });

  final DetailsView widget;
  final Meal? items;
  @override
  State<_MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<_MealDetails> {
  late int selectedIndex;
  int index = 0;
  Future<void> launch(Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(ProjectTexts.linkError),
        ),
      );
    } else {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  final favoriteMealBox = Hive.box<Meal>(ProjectTexts.favoriteBoxName);
  final meals = Meals();

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: widget.items?.meals?.length ?? 0,
      itemBuilder: (context, index) {
        final meals = widget.items?.meals?[index];
        final ingList = [
          meals?.strIngredient1 ?? '',
          meals?.strIngredient2 ?? '',
          meals?.strIngredient3 ?? '',
          meals?.strIngredient4 ?? '',
          meals?.strIngredient5 ?? '',
          meals?.strIngredient6 ?? '',
          meals?.strIngredient7 ?? '',
          meals?.strIngredient8 ?? '',
          meals?.strIngredient9 ?? '',
          meals?.strIngredient10 ?? '',
          meals?.strIngredient11 ?? '',
          meals?.strIngredient12 ?? '',
          meals?.strIngredient13 ?? '',
          meals?.strIngredient14 ?? '',
          meals?.strIngredient15 ?? '',
          meals?.strIngredient16 ?? '',
          meals?.strIngredient17 ?? '',
          meals?.strIngredient18 ?? '',
          meals?.strIngredient19 ?? '',
          meals?.strIngredient20 ?? '',
        ];
        final measureList = <String?>[
          meals?.strMeasure1 ?? '',
          meals?.strMeasure2 ?? '',
          meals?.strMeasure3 ?? '',
          meals?.strMeasure4 ?? '',
          meals?.strMeasure5 ?? '',
          meals?.strMeasure6 ?? '',
          meals?.strMeasure7 ?? '',
          meals?.strMeasure8 ?? '',
          meals?.strMeasure9 ?? '',
          meals?.strMeasure10 ?? '',
          meals?.strMeasure11 ?? '',
          meals?.strMeasure12 ?? '',
          meals?.strMeasure13 ?? '',
          meals?.strMeasure14 ?? '',
          meals?.strMeasure15 ?? '',
          meals?.strMeasure16 ?? '',
          meals?.strMeasure17 ?? '',
          meals?.strMeasure18 ?? '',
          meals?.strMeasure19 ?? '',
          meals?.strMeasure20 ?? '',
        ];

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Text(
                        widget.widget.name ?? '',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: CircleAvatar(
                          backgroundColor: ProjectColors.actionsBgColor,
                          child: SvgPicture.asset(
                            AssetsPath.bookmark,
                            color: ProjectColors.black,
                          ),
                        ),
                        onPressed: () async {
                          await DetailModels().onFavoritePress(
                            widget.widget.id,
                            widget.widget.name ?? '',
                            widget.widget.image ?? '',
                            ingList,
                            meals?.strInstructions ?? '',
                            meals?.strYoutube ?? '',
                            meals?.strCategory ?? '',
                            meals?.strSource ?? '',
                            measureList,
                            countryFlagMap[meals?.strArea] ?? '',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryName(meals: meals),
                    AreaImage(meals: meals),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 50,
                      child: TextButton(
                        autofocus: true,
                        onPressed: () async {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: (selectedIndex == 0) ? 1.2 : 1,
                          child: Text(
                            ProjectTexts.ingredients,
                            style: (selectedIndex == 0)
                                ? Theme.of(context).textTheme.headline3
                                : Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: (selectedIndex == 1) ? 1.2 : 1,
                          child: Text(
                            ProjectTexts.instructions,
                            style: (selectedIndex == 1)
                                ? Theme.of(context).textTheme.headline3
                                : Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (selectedIndex == 0)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int index = 0;
                          index < ingList.length && index.isFinite;
                          index++)
                        ingList[index].isNotNullOrNoEmpty
                            ? _ingredients(
                                ingList,
                                index,
                                context,
                                measureList,
                              )
                            : const SizedBox.shrink(),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meals?.strInstructions ?? ''),
                      TextButton(
                        onPressed: () {
                          launch(
                            Uri.parse(
                              meals?.strYoutube ?? '',
                            ),
                          );
                        },
                        child: const Text('Watch Video'),
                      ),
                      TextButton(
                        onPressed: () {
                          launch(
                            Uri.parse(
                              meals?.strSource ?? '',
                            ),
                          );
                        },
                        child: const Text('Source'),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  SizedBox _ingredients(
    List<String?> ingList,
    int index,
    BuildContext context,
    List<String?> measureList,
  ) {
    return SizedBox(
      height: 60,
      width: 325,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Card(
              color: ProjectColors.lightGrey,
              child: CachedNetworkImage(
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 60,
                height: 60,
                imageUrl: '${EndPoints.ingredientsImages}${ingList[index]}-small.png',
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: ProjectPaddings.textLarge,
              child: Text(
                '${ingList[index]}'.capitalize(),
                style: Theme.of(context).textTheme.headline3,
              ).toVisible(
                ingList[index] != null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text('${measureList[index]}').toVisible(
              measureList[index] != null,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryName extends StatelessWidget {
  const CategoryName({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Padding(
        padding: ProjectPaddings.cardLarge,
        child: Text('in ${meals?.strCategory}').toVisible(
          meals?.strCategory != null,
        ),
      ),
    );
  }
}

class AreaImage extends StatelessWidget {
  const AreaImage({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: CachedNetworkImage(
        imageUrl: countryFlagMap[meals?.strArea] ?? '',
        height: 32,
        width: 32,
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
        ),
        progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
          height: 32,
          width: 32,
          child: Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
