import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartal/kartal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thefood/constants/assets_path.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.image,
    required this.id,
    super.key,
    required this.name,
  });
  final String? image;
  final String name;
  final int id;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late SharedPreferences prefs;
  late final Future<Meal?> _meals;

  @override
  void initState() {
    _meals = NetworkManager.instance.getMeal(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: ProjectColors.actionsBgColor,
              child: SvgPicture.asset(
                AssetsPath.bookmark,
                color: ProjectColors.black,
              ),
            ),
            onPressed: () async {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.image ?? ''),
                  fit: BoxFit.fitWidth,
                ),
              ),
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
                child: FutureBuilder<Meal?>(
                  future: _meals,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _MealDetails(
                        widget: widget,
                        items: snapshot.data?.meals ?? [],
                      );
                    } else if (snapshot.hasError) {}
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
  final List<Meals?> items;

  @override
  State<_MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<_MealDetails> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final meals = widget.items[index];
        final ingList = [
          meals?.strIngredient1,
          meals?.strIngredient2,
          meals?.strIngredient3,
          meals?.strIngredient4,
          meals?.strIngredient5,
          meals?.strIngredient6,
          meals?.strIngredient7,
          meals?.strIngredient8,
          meals?.strIngredient9,
          meals?.strIngredient10,
          meals?.strIngredient11,
          meals?.strIngredient12,
          meals?.strIngredient13,
          meals?.strIngredient14,
          meals?.strIngredient15,
          meals?.strIngredient16,
          meals?.strIngredient17,
          meals?.strIngredient18,
          meals?.strIngredient19,
          meals?.strIngredient20,
        ];
        final measureList = <String?>[
          meals?.strMeasure1,
          meals?.strMeasure2,
          meals?.strMeasure3,
          meals?.strMeasure4,
          meals?.strMeasure5,
          meals?.strMeasure6,
          meals?.strMeasure7,
          meals?.strMeasure8,
          meals?.strMeasure9,
          meals?.strMeasure10,
          meals?.strMeasure11,
          meals?.strMeasure12,
          meals?.strMeasure13,
          meals?.strMeasure14,
          meals?.strMeasure15,
          meals?.strMeasure16,
          meals?.strMeasure17,
          meals?.strMeasure18,
          meals?.strMeasure19,
          meals?.strMeasure20,
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.widget.name,
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: ProjectPaddings.cardLarge,
              child: Text('in ${meals?.strCategory}').toVisible(
                meals?.strCategory != null,
              ),
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
                  for (int index = 0; index < ingList.length && index.isFinite; index++)
                    ingList[index].isNotNullOrNoEmpty
                        ? _ingredients(ingList, index, context, measureList)
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
                      launch(Uri.parse(meals?.strYoutube ?? ''));
                    },
                    child: const Text('Watch Video'),
                  ),
                  TextButton(
                    onPressed: () {
                      launch(Uri.parse(meals?.strSource ?? ''));
                    },
                    child: const Text('Source'),
                  ),
                ],
              ),
          ],
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
          Card(
            color: ProjectColors.lightGrey,
            child: Image.network(
              excludeFromSemantics: true,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
              width: 60,
              height: 60,
              '${EndPoints.ingredientsImages}${ingList[index]}-small.png',
            ),
          ),
          Padding(
            padding: ProjectPaddings.textLarge,
            child: Text(
              '${ingList[index]}'.capitalize(),
              style: Theme.of(context).textTheme.headline3,
            ).toVisible(
              ingList[index] != null,
            ),
          ),
          const Spacer(),
          Text('${measureList[index]}').toVisible(
            measureList[index] != null,
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
