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
            return Container(
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
            context.goNamed('/');
          },
        ),
      ),
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: Stack(
        children: <Widget>[
          if (connected)
            Positioned.fill(
              child: CachedNetworkImage(
                filterQuality: FilterQuality.medium,
                imageUrl: widget.image ?? '',
                fit: BoxFit.cover,
              ),
            )
          else if (!connected && widget.image != null)
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
            if (connected && isUserRecipe == false)
              _MealDetails(
                isUserRecipe: isUserRecipe,
                items: state.meal,
                favoriteCacheManager: context.read<DetailsCubit>().favoriteCacheManager,
              )
            else if (connected == false)
              _MealDetails(
                isUserRecipe: isUserRecipe,
                items: state.favoriteMealDetail,
                favoriteCacheManager: context.read<DetailsCubit>().favoriteCacheManager,
              )
            else if (connected && isUserRecipe)
              _MealDetails(
                isUserRecipe: isUserRecipe,
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
    required this.isUserRecipe,
    required this.items,
    required this.favoriteCacheManager,
  });
  final Meal? items;
  final ICacheManager<Meal>? favoriteCacheManager;
  final bool isUserRecipe;
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
                      isUserRecipe: widget.isUserRecipe,
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
    required this.isUserRecipe,
  });

  late int selectedIndex;
  List<String?> ingredientList;
  List<String?> measureList;
  final bool isUserRecipe;
  final Meals? meals;

  @override
  State<ComponentAndGuide> createState() => _ComponentAndGuideState();
}

class _ComponentAndGuideState extends State<ComponentAndGuide> {
  final _titleController = TextEditingController();
  final _reviewController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget bodyChanger() {
    // ignore: omit_local_variable_types
    double userRating = 0;
    switch (widget.selectedIndex) {
      case 0:
        return _ingredientListBody();
      case 1:
        return Instructions(meals: widget.meals, isUserRecipe: widget.isUserRecipe);
      case 2:
        return Column(
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('reviews')
                  .doc(widget.meals?.idMeal)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data?.data()?['review'] != null) {
                    final data = snapshot.data?.data()?['review'] as List;
                    return SizedBox(
                      height: context.dynamicHeight(0.44),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final review = data[index] as Map<String, dynamic>;
                          final timestamp = review['review_time'] as Timestamp;
                          return UserReviewCard(review: review, timestamp: timestamp);
                        },
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: context.dynamicHeight(0.44),
                    child: Card(
                      child: Center(
                        child: Text(snapshot.error.toString()),
                      ),
                    ),
                  );
                }
                if (snapshot.data?.data() == null &&
                    snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: context.dynamicHeight(0.44),
                    child: Card(
                      child: Center(
                        child: Text(
                          'No reviews yet',
                          style: context.textTheme.headline1,
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: context.dynamicHeight(0.44),
                  child: Card(
                    child: Center(
                      child: SizedBox(
                        height: context.dynamicHeight(0.2),
                        child: CustomLottieLoading(
                          path: AssetsPath.progression,
                          onLoaded: (composition) {},
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: context.dynamicHeight(0.02),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: context.dynamicHeight(0.06),
                width: context.dynamicWidth(0.6),
                child: ElevatedButton(
                  onPressed: () {
                    AlertWidgets.showActionDialog(
                        context,
                        'Add Review',
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              RatingBar(
                                itemSize: context.dynamicWidth(0.1),
                                glow: false,
                                ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star, color: Colors.amber),
                                  half: const Icon(Icons.star_half, color: Colors.amber),
                                  empty:
                                      const Icon(Icons.star_border, color: Colors.amber),
                                ),
                                onRatingUpdate: (rating) {
                                  userRating = rating;
                                },
                                allowHalfRating: true,
                              ),
                              SizedBox(height: context.dynamicHeight(0.03)),
                              SizedBox(
                                height: context.dynamicHeight(0.10),
                                width: context.dynamicWidth(0.6),
                                child: TextFormField(
                                  style: context.textTheme.headline4,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter a title';
                                    }
                                    return null;
                                  },
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    hintText: 'Title',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(height: context.dynamicHeight(0.01)),
                              SizedBox(
                                height: context.dynamicHeight(0.15),
                                width: context.dynamicWidth(0.6),
                                child: TextFormField(
                                  style: context.textTheme.headline4,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter a review';
                                    }
                                    return null;
                                  },
                                  controller: _reviewController,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    hintText: 'Add your comment',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              _titleController.clear();
                              _reviewController.clear();
                            },
                            child: Text('Cancel', style: context.textTheme.bodyText2),
                          ),
                          _SendReviewToDb(
                            formKey: _formKey,
                            widget: widget,
                            titleController: _titleController,
                            reviewController: _reviewController,
                            userRating: userRating,
                            context: context,
                          )
                        ]);
                  },
                  child: Text(
                    'Add Review',
                    style: context.textTheme.headline3,
                  ),
                ),
              ),
            ),
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

  Column _ingredientListBody() {
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
        bodyChanger()
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
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline3,
              ).toVisible(
                widget.ingredientList[index] != null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${widget.measureList[index]}',
              overflow: TextOverflow.ellipsis,
            ).toVisible(
              widget.measureList[index] != null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SendReviewToDb extends StatelessWidget {
  const _SendReviewToDb({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.widget,
    required TextEditingController titleController,
    required TextEditingController reviewController,
    required this.userRating,
    required this.context,
  })  : _formKey = formKey,
        _titleController = titleController,
        _reviewController = reviewController;

  final GlobalKey<FormState> _formKey;
  final ComponentAndGuide widget;
  final TextEditingController _titleController;
  final TextEditingController _reviewController;
  final double userRating;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        // I tried to check if the user added review and add but i didn't figure out
        // in update deleted all the reviews and added new one
        if (_formKey.currentState?.validate() ?? false) {
          final reviewData = <Map<String, dynamic>>[
            {
              'idMeal': widget.meals?.idMeal ?? '',
              'user_id': FirebaseAuth.instance.currentUser?.uid,
              'user_name': FirebaseAuth.instance.currentUser?.displayName,
              'photoURL': FirebaseAuth.instance.currentUser?.photoURL,
              'title': _titleController.text,
              'review': _reviewController.text,
              'rating': userRating,
              'review_time': Timestamp.now(),
            }
          ];
          await FirebaseFirestore.instance
              .collection('reviews')
              .doc(widget.meals?.idMeal)
              .set(
            {
              'review': FieldValue.arrayUnion(reviewData),
            },
            SetOptions(merge: true),
          ).whenComplete(
            () => AlertWidgets.showMessageDialog(
              context,
              'Success',
              'Review added successfully',
            ),
          );
          Navigator.pop(context);
          _titleController.clear();
          _reviewController.clear();
        }
      },
      child: Text('Send', style: context.textTheme.bodyText2),
    );
  }
}

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({
    super.key,
    required this.review,
    required this.timestamp,
  });

  final Map<String, dynamic> review;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: context.paddingLow,
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
                        CircleAvatar(
                          radius: context.dynamicWidth(0.07),
                          backgroundColor: ProjectColors.mainWhite,
                          foregroundImage: AssetImage(
                            '${review['photoURL']}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              '${review['user_name']}'.replaceRange(
                                2,
                                '${review['user_name']}'.length,
                                '*******',
                              ),
                              style: context.textTheme.bodyText2?.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            ProjectWidgets.buildRatingStar(
                              double.parse('${review['rating']}'),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            TimeAgo.format(
                              DateTime.parse(
                                timestamp.toDate().toString(),
                              ),
                              locale: 'en_short',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: const Alignment(-0.8, -0.1),
                      child: Text(
                        '${review['title']}',
                        style: context.textTheme.bodyText2?.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.8, 0),
                      child: Text(
                        '${review['review']}',
                        style: context.textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

class ComponentChanger extends StatefulWidget {
  ComponentChanger({
    super.key,
    required this.selectedIndex,
  });

  late int selectedIndex;

  @override
  State<ComponentChanger> createState() => _ComponentChangerState();
}

class _ComponentChangerState extends State<ComponentChanger> {
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
    required this.isUserRecipe,
  });

  final Meals? meals;
  final bool isUserRecipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(meals?.strInstructions ?? ''),
        // They are opening twice idk why
        GoToYoutube(
          meals: meals,
        ),
        GoToSource(meals: meals, isUserRecipe: isUserRecipe),
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
    required this.isUserRecipe,
  });
  final Meals? meals;
  final bool isUserRecipe;

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
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            launch(
              Uri.parse(
                widget.meals?.strSource ?? '',
              ),
            );
          },
          child: const Text('Source'),
        ),
        const Spacer(),
        if (widget.isUserRecipe)
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('recipes')
                .where('idMeal', isEqualTo: widget.meals?.idMeal)
                .get(),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              return TextButton(
                child: Text('Added by ${data?.first.data()['name']}'),
                onPressed: () async {
                  final user = FirebaseFirestore.instance
                      .collection('users')
                      .doc(data?.first.data()['userId'] as String)
                      .get();

                  final userName = await user
                      .then((value) => value.data()?['name'].toString().split(' ')[0]);
                  final userPhoto = await user.then((value) => value.data()?['photoURL']);
                  final userCountry =
                      await user.then((value) => value.data()?['country']);
                  final userRecipes = await user.then((value) => value.data());
                  await AlertWidgets.showActionDialog(
                    context,
                    "$userName 's Profile",
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(userPhoto as String),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$userName is from $userCountry',
                        ),
                      ],
                    ),
                    [
                      // i will try to add later
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'To see all recipes he/she added, click here',
                            style: context.textTheme.headline4,
                          )),
                    ],
                  );
                },
              );
            },
          )
        else
          const SizedBox.shrink()
      ],
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
            child: CustomLottieLoading(
              path: AssetsPath.progression,
              onLoaded: (composition) {
                downloadProgress.progress;
              },
            ),
          ),
        ),
      ),
    );
  }
}
