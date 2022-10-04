part of 'home_view.dart';

FutureBuilder<Area?> _areaList(Future<Area?> area) {
  return FutureBuilder<Area?>(
    future: area,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Padding(
          padding: ProjectPaddings().cardMedium,
          child: Column(
            children: [
              const _AlignedText(text: ProjectTexts.areas),
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
                                  'name': data?.strArea ?? '',
                                  'image': countryFlagMap[data?.strArea] ?? '',
                                },
                              );
                            },
                            child: _ImageBox(
                              url: countryFlagMap[data?.strArea] ?? '',
                            ),
                          ),
                          Text(
                            data?.strArea ?? '',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
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