import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/network_manager.dart';

class CategoryDetailsView extends StatefulWidget {
  const CategoryDetailsView({
    this.image,
    super.key,
    required this.name,
  });
  final String? image;
  final String name;
  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<CategoryDetailsView> {
  final manager = NetworkManager.instance;
  late final Future<Meal?> _categoryMeals;
  late final String _name;
  @override
  void initState() {
    _name = widget.name;
    _categoryMeals = manager.getMealsByCategory(_name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: ProjectPaddings().pageMedium,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Row(
                  children: [
                    Image.network(
                      widget.image ?? '',
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      'Here is the recipies for ${widget.name}',
                      textScaleFactor: 0.6,
                    ),
                  ],
                ),
              ),
              FutureBuilder<Meal?>(
                future: _categoryMeals,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      physics: const ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                        mainAxisExtent: MediaQuery.of(context).size.height / 3.8,
                      ),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.meals?.length,
                      itemBuilder: (context, index) {
                        final main = snapshot.data?.meals?[index];
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3.8,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(
                                        'details',
                                        params: {
                                          'name': main?.strMeal ?? '',
                                          'image': main?.strMealThumb ?? '',
                                          'id': main?.idMeal ?? '',
                                        },
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 200,
                                            height: 160,
                                            margin: const EdgeInsets.all(16),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.all(18),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      main?.strMeal ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black12,
                                            ),
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                main?.strMealThumb ?? '',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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
          ),
        ),
      ),
    );
  }
}
