part of 'home_view.dart';

FutureBuilder<List<MealCategory>?> _categoriesList(
    Future<List<MealCategory>?> categories) {
  return FutureBuilder<List<MealCategory>?>(
    future: categories,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Column(
          children: [
            const _AlignedText(text: ProjectTexts.categories),
            _CardBox(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data?[index];
                  return Card(
                    child: Column(
                      children: [
                        _ImageBox(
                          url: data?.strCategoryThumb ?? '',
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
