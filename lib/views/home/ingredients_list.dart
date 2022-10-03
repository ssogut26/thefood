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
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.meals?.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data?.meals?[index];
                    return Card(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                'details',
                                params: {
                                  'name': data?.strIngredient ?? '',
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
