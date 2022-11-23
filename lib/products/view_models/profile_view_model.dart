part of '../views/profile/profile_view.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    super.key,
  });

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final userRef = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FirebaseAuth.instance.currentUser?.displayName.toString() ?? '',
        ),
        FutureBuilder(
          future: userRef.doc(FirebaseAuth.instance.currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data?.data();
              return Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: countryFlags['${data?['country']}'] ?? '',
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
                  Padding(
                    padding: ProjectPaddings.textHorizontalSmall,
                    child: Text(
                      '${data?['country']}',
                    ),
                  ),
                ],
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
      ],
    );
  }
}

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Center(
          child: FutureBuilder<String>(
            future: context.read<ProfileCubit>().getUserImage(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.asset(
                  snapshot.data ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              }
              if (snapshot.hasError) {
                kDebugMode ? print(snapshot.error) : null;
                return const Icon(Icons.error);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }
}

class FutureUserRecipe extends StatelessWidget {
  const FutureUserRecipe({
    super.key,
    required this.getUserRecipe,
  });

  final Future<QuerySnapshot<Map<String, dynamic>>> getUserRecipe;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>?>?>(
      future: getUserRecipe,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(ProjectTexts.somethingWentWrong);
        }
        if (snapshot.hasData && (snapshot.data?.docs.isEmpty ?? true)) {
          return const NoRecipeCard();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data?.docs;
          return UserRecipesCard(data: data);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class NoRecipeCard extends StatelessWidget {
  const NoRecipeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.2),
      child: const Card(
        elevation: 2,
        child: Center(child: Text(ProjectTexts.userNoRecipesYet)),
      ),
    );
  }
}

class UserRecipesCard extends StatelessWidget {
  const UserRecipesCard({
    super.key,
    required this.data,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>?>>? data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(0.25),
      width: context.dynamicWidth(1),
      child: ListView.builder(
        itemCount: data?.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                SizedBox(
                  height: context.dynamicHeight(0.12),
                  width: context.dynamicWidth(0.4),
                  child: Image.network(
                    fit: BoxFit.cover,
                    "${data?[index]['strMealThumb']}",
                  ),
                ),
                Padding(
                  padding: ProjectPaddings.textHorizontalMedium,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${data?[index]['strMeal']}\n'),
                      Text('${data?[index]['strCategory']}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
