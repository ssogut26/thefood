part of '../views/details/details_view.dart';

class DetailsBody extends StatelessWidget {
  const DetailsBody({
    super.key,
    required this.connected,
    required this.isUserRecipe,
  });
  final bool connected;
  final bool isUserRecipe;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) {
            return Padding(
              padding: context.paddingLow,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: ProjectColors.mainWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: context.lowRadius,
                    topRight: context.lowRadius,
                  ),
                ),
                child: Padding(
                  padding: ProjectPaddings.pageLarge,
                  child: AllDetailsView(
                    connected: connected,
                    isUserRecipe: isUserRecipe,
                  ),
                ),
              ),
            );
          },
        ),
        childCount: 1,
      ),
    );
  }
}

class RecipeImage extends StatelessWidget {
  const RecipeImage({
    super.key,
    required this.connected,
    required this.widget,
  });

  final bool connected;
  final DetailsView widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Padding(
        padding: ProjectPaddings.cardSmall,
        child: IconButton(
          icon: CircleAvatar(
            backgroundColor: ProjectColors.actionsBgColor,
            child: SvgPicture.asset(
              AssetsPath.back,
              color: ProjectColors.black,
            ),
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: Stack(
        children: <Widget>[
          if (connected || (DioErrorType.other == SocketException))
            Positioned.fill(
              child: CachedNetworkImage(
                filterQuality: FilterQuality.medium,
                imageUrl: widget.image ?? '',
                fit: BoxFit.cover,
              ),
            )
          else
            const Center(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}

class AllDetailsView extends StatelessWidget {
  const AllDetailsView({
    super.key,
    required this.connected,
    required this.isUserRecipe,
  });

  final bool connected;
  final bool isUserRecipe;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.favoriteMealDetail?.meals?.isNotNullOrEmpty ?? false)
              _MealDetails(
                items: state.favoriteMealDetail,
                favoriteCacheManager: context.read<DetailsCubit>().favoriteCacheManager,
              )
            else if (connected && isUserRecipe == false)
              _MealDetails(
                items: state.meal,
                favoriteCacheManager: context.read<DetailsCubit>().favoriteCacheManager,
              )
            else if (connected && isUserRecipe)
              _MealDetails(
                items: state.favoriteMealDetail,
                favoriteCacheManager: context.read<DetailsCubit>().favoriteCacheManager,
              )
            else
              const NoConnectionView(),
          ],
        );
      },
    );
  }
}

class NoConnectionView extends StatelessWidget {
  const NoConnectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ProjectColors.mainWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsPath.noConnectionImage,
            ),
            Text(
              ProjectTexts.noConnection,
              style: context.textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealDetails extends StatefulWidget {
  const _MealDetails({
    required this.items,
    required this.favoriteCacheManager,
  });
  final Meal? items;
  final ICacheManager<Meal>? favoriteCacheManager;
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: state.favoriteMealDetail?.meals?.length ?? 0,
          itemBuilder: (context, index) {
            final meals = state.favoriteMealDetail?.meals?[index];

            // Function one is for list from api other is from firestore
            final ingredientList = meals?.strIngredients ?? meals?.getIngredients() ?? [];
            final measureList = meals?.strMeasures ?? meals?.getMeasures() ?? [];
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
                        MealName(meals: meals),
                        const AddFavoriteButton(),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryName(meals: meals),
                        AreaImage(meals: meals),
                      ],
                    ),
                    ComponentAndGuide(
                      selectedIndex: selectedIndex,
                      meals: meals,
                      ingredientList: ingredientList,
                      measureList: measureList,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class MealName extends StatelessWidget {
  const MealName({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 12,
      child: Text(
        meals?.strMeal ?? '',
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}

class ComponentAndGuide extends StatefulWidget {
  ComponentAndGuide({
    super.key,
    required this.selectedIndex,
    required this.ingredientList,
    required this.measureList,
    required this.meals,
  });

  late int selectedIndex;
  List<String?> ingredientList;
  List<String?> measureList;
  final Meals? meals;

  @override
  State<ComponentAndGuide> createState() => _ComponentAndGuideState();
}

class _ComponentAndGuideState extends State<ComponentAndGuide> {
  final _titleController = TextEditingController();
  final _reviewController = TextEditingController();

  Widget getVs() {
    switch (widget.selectedIndex) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int index = 0;
                index < widget.ingredientList.length && index.isFinite;
                index++)
              widget.ingredientList[index].isNotNullOrNoEmpty
                  ? _requirements(index, context)
                  : const SizedBox.shrink(),
          ],
        );
      case 1:
        return Instructions(
          meals: widget.meals,
        );
      case 2:
        // it will be listview.builder
        return Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('meal_id', isEqualTo: widget.meals?.idMeal)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: data?.docs.length,
                    itemBuilder: (context, index) {
                      final review = data?.docs[index];
                      var timestamp = review?.data()['review_time'] as Timestamp;
                      var date = timestamp.toDate();

                      return SizedBox(
                        height: context.dynamicHeight(0.44),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                child: Padding(
                                  padding: context.paddingLow,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // will be user image or dummy image
                                            CircleAvatar(
                                                foregroundImage: NetworkImage(
                                                    '${review?['photoURL']}')),
                                            const SizedBox(width: 10),
                                            Column(
                                              children: [
                                                Text(
                                                  '${review?['user_name']}',
                                                  style: context.textTheme.bodyText2,
                                                ),
                                                buildRatingStar(
                                                  double.parse('${review?['rating']}'),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            Text(
                                              timeago.format(
                                                DateTime.parse(
                                                  timestamp.toDate().toString(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: const Alignment(-0.8, 0),
                                          child: Text(
                                            '${review?['review']}',
                                            style: context.textTheme.bodyText1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Add Review',
                          style: context.textTheme.headline2,
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final checkAlreadyReviewed = FirebaseFirestore.instance
                                  .collection('reviews')
                                  .where(
                                    'user_id',
                                    isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                                  )
                                  .get();

                              await FirebaseFirestore.instance.collection('reviews').add({
                                'user_id': FirebaseAuth.instance.currentUser?.uid,
                                'user_name':
                                    FirebaseAuth.instance.currentUser?.displayName,
                                'photoURL': FirebaseAuth.instance.currentUser?.photoURL,
                                'meal_id': widget.meals?.idMeal,
                                'title': _titleController.text,
                                'review': _reviewController.text,
                                'rating': 4,
                                'review_time': Timestamp.now(),
                              });
                              // } else {
                              //   return showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         title: Text(
                              //           'You have already reviewed this meal',
                              //           style: context.textTheme.headline2,
                              //         ),
                              //         actions: [
                              //           ElevatedButton(
                              //             onPressed: () {
                              //               Navigator.pop(context);
                              //             },
                              //             child: const Text('OK'),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );
                              // }
                            },
                            child: const Text('Send'),
                          ),
                        ],
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildRatingStar(4),
                              SizedBox(height: context.dynamicHeight(0.03)),
                              SizedBox(
                                height: context.dynamicHeight(0.07),
                                child: TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    hintText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: context.dynamicHeight(0.2),
                                child: TextField(
                                  controller: _reviewController,
                                  maxLines: 4,
                                  decoration: const InputDecoration(
                                    hintText: 'Add your comment',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Add Review'),
              ),
            )
          ],
        );

      default:
        return const SizedBox(
          child: Center(
            child: Text('No review'),
          ),
        );
    }
  }

  Widget buildRatingStar(double starValue) {
    final Color color = starValue < 2 ? Colors.red : Colors.green;
    final starIconsMap = [1, 2, 3, 4, 5].map((e) {
      if (starValue >= e) {
        return Icon(
          size: 15,
          Icons.star_rate,
          color: color,
        );
      } else if (starValue < e && starValue > e - 1) {
        return Icon(
          size: 15,
          Icons.star_half,
          color: color,
        );
      } else {
        return Icon(size: 15, Icons.star_border, color: color);
      }
    }).toList();

    return Row(children: starIconsMap);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 33,
              child: TextButton(
                autofocus: true,
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      widget.selectedIndex = 0;
                    });
                  }
                },
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: (widget.selectedIndex == 0) ? 1.2 : 1,
                  child: Text(
                    ProjectTexts.ingredients,
                    style: (widget.selectedIndex == 0)
                        ? Theme.of(context).textTheme.headline3
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 33,
              child: TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      widget.selectedIndex = 1;
                    });
                  }
                },
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: (widget.selectedIndex == 1) ? 1.2 : 1,
                  child: Text(
                    ProjectTexts.instructions,
                    style: (widget.selectedIndex == 1)
                        ? Theme.of(context).textTheme.headline3
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 33,
              child: TextButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      widget.selectedIndex = 2;
                    });
                  }
                },
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: (widget.selectedIndex == 2) ? 1.2 : 1,
                  child: Text(
                    'Comments',
                    style: (widget.selectedIndex == 2)
                        ? Theme.of(context).textTheme.headline3
                        : Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
            ),
          ],
        ),
        getVs()
      ],
    );
  }

  SizedBox _requirements(int index, BuildContext context) {
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
                filterQuality: FilterQuality.medium,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 60,
                height: 60,
                imageUrl:
                    '${EndPoints.ingredientsImages}${widget.ingredientList[index]}-small.png',
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: ProjectPaddings.textHorizontalLarge,
              child: Text(
                '${widget.ingredientList[index]}'.capitalize(),
                style: Theme.of(context).textTheme.headline3,
              ).toVisible(
                widget.ingredientList[index] != null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text('${widget.measureList[index]}').toVisible(
              widget.measureList[index] != null,
            ),
          ),
        ],
      ),
    );
  }
}

class AddFavoriteButton extends StatefulWidget {
  const AddFavoriteButton({
    super.key,
  });

  @override
  State<AddFavoriteButton> createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        return Expanded(
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
              context.read<DetailsCubit>().favoriteCacheManager.getValues();
              if (context
                      .read<DetailsCubit>()
                      .favoriteMealDetail
                      ?.meals
                      .isNotNullOrEmpty ??
                  false) {
                await context.read<DetailsCubit>().favoriteCacheManager.putItem(
                      state.id.toString(),
                      state.favoriteMealDetail!,
                    );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to favorites'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CompomentChanger extends StatefulWidget {
  CompomentChanger({
    super.key,
    required this.selectedIndex,
  });

  late int selectedIndex;

  @override
  State<CompomentChanger> createState() => _CompomentChangerState();
}

class _CompomentChangerState extends State<CompomentChanger> {
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 50,
          child: TextButton(
            autofocus: true,
            onPressed: () {
              if (mounted) {
                setState(() {
                  selectedIndex = 0;
                });
              }
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
              if (mounted) {
                setState(() {
                  selectedIndex = 1;
                });
              }
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
    );
  }
}

class Instructions extends StatelessWidget {
  const Instructions({
    super.key,
    required this.meals,
  });

  final Meals? meals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meals?.strInstructions ?? ''),
        GoToYoutube(
          meals: meals,
        ),
        GoToSource(meals: meals),
      ],
    );
  }
}

class GoToYoutube extends StatefulWidget {
  const GoToYoutube({
    required this.meals,
    super.key,
  });
  final Meals? meals;

  @override
  State<GoToYoutube> createState() => _GoToYoutubeState();
}

class _GoToYoutubeState extends State<GoToYoutube> {
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
    return TextButton(
      onPressed: () {
        launch(
          Uri.parse(
            widget.meals?.strYoutube ?? '',
          ),
        );
      },
      child: const Text('Watch Video'),
    );
  }
}

class GoToSource extends StatefulWidget {
  const GoToSource({
    required this.meals,
    super.key,
  });
  final Meals? meals;

  @override
  State<GoToSource> createState() => _GoToSourceState();
}

class _GoToSourceState extends State<GoToSource> {
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
    return TextButton(
      onPressed: () {
        launch(
          Uri.parse(
            widget.meals?.strSource ?? '',
          ),
        );
      },
      child: const Text('Source'),
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
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
          child: SizedBox(
            height: 16,
            width: 16,
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
