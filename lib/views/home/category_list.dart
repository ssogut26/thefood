part of 'home_view.dart';

FutureBuilder<List<MealCategory>?> _categoriesList(
  Future<List<MealCategory>?> categories,
) {
  return FutureBuilder<List<MealCategory>?>(
    future: categories,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            SizedBox(
              height: 64,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data?[index];
                  return Card(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                              'category',
                              params: {
                                'name': data?.strCategory ?? '',
                                'image': data?.strCategoryThumb ?? '',
                              },
                            );
                          },
                          child: Card(
                            color: ProjectColors.mainWhite,
                            child: Image.network(
                              data?.strCategoryThumb ?? '',
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                        Text(
                          data?.strCategory ?? '',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
