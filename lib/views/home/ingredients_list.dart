part of 'home_view.dart';

FutureBuilder<Ingredients?> _ingredientsList(Future<Ingredients?> ingredients) {
  return FutureBuilder<Ingredients?>(
    future: ingredients,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Padding(
          padding: ProjectPaddings().cardMedium,
          child: Column(
            children: [
              const _AlignedText(text: ProjectTexts.ingredients),
              _CardBox(
                child: PaginableListView.builder(
                  errorIndicatorWidget: (exception, tryAgain) => Container(
                    color: Colors.redAccent,
                    height: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          exception.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                          ),
                          onPressed: () {},
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                  progressIndicatorWidget: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loadMore: () async {
                    var increase = 20;
                    for (var i = 20; i < 590; i++) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      snapshot.data!.meals!.length + i;
                    }
                  },
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.meals!.length - 500,
                  itemBuilder: (context, index) {
                    final data = snapshot.data?.meals?[index];
                    return Card(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.go(
                                '/details',
                                extra: {
                                  'id': data?.idIngredient,
                                  'name': data?.strIngredient,
                                  'image':
                                      '${EndPoints().ingredientsImages}${data?.strIngredient ?? ''}.png',
                                },
                              );
                            },
                            child: _ImageBox(
                              url:
                                  '${EndPoints().ingredientsImages}${data?.strIngredient ?? ''}.png',
                            ),
                          ),
                          Text(
                            data?.strIngredient ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
