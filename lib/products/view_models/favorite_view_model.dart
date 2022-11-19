part of '../views/favorites/favorite_view.dart';

bool isLoading = true;

class AllFavorites extends StatelessWidget {
  const AllFavorites({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: context.read<FavoritesCubit>().onRefresh(),
          child: Padding(
            padding: ProjectPaddings.pageMedium,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: context.watch<FavoritesCubit>().favoriteBox?.length,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemBuilder: (context, index) {
                  final meal = state.favoriteBox?[index]?.meals;
                  return MealCard(meal: meal);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ProjectPaddings.cardMedium,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'details',
            params: {
              'id': meal?.map((e) => e.idMeal).toString().deletePharanteses() ?? '',
              'name': meal?.map((e) => e.strMeal).toString().deletePharanteses() ?? '',
              'image':
                  meal?.map((e) => e.strMealThumb).toString().deletePharanteses() ?? '',
            },
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.20,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                MealImage(meal: meal),
                MealName(meal: meal),
                DeleteButton(meal: meal),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MealImage extends StatelessWidget {
  const MealImage({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.40,
      child: CachedNetworkImage(
        imageUrl: meal?.map((e) => e.strMealThumb).toString().deletePharanteses() ?? '',
        fit: BoxFit.fill,
      ),
    );
  }
}

class MealName extends StatelessWidget {
  const MealName({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: ProjectPaddings.textHorizontalMedium,
        child: Text(
          softWrap: true,
          meal?.map((e) => e.strMeal).toString().deletePharanteses() ?? '',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.meal,
  });

  final List<Meals>? meal;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<FavoritesCubit>().removeItem(
              meal?.map((e) => e.idMeal).toString().deletePharanteses() ?? '',
            );
      },
      icon: const Icon(Icons.delete),
    );
  }
}

class PullToRefresh extends StatelessWidget {
  const PullToRefresh({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          await context.read<FavoritesCubit>().fetchListOfFavorites();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${ProjectTexts.noFavoritesYet}\n\n',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      TextSpan(
                        text: 'To refresh, pull down',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              letterSpacing: 0.5,
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
  }
}

AppBar _appBar(BuildContext context) {
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
    title: Text(
      ProjectTexts.favoriteBoxName,
      style: Theme.of(context).textTheme.headline1,
    ),
  );
}

extension on String {
  String deletePharanteses() {
    return substring(1, length - 1);
  }
}
