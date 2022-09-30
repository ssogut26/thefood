import 'package:flutter/material.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/category.dart';
import 'package:thefood/services/network_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('theFood'),
      ),
      body: Padding(
        padding: ProjectPaddings().medium,
        child: Column(
          children: [
            FutureBuilder<List<MealCategory>?>(
              future: NetworkManager.instance.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Categories',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Column(
                                children: [
                                  Image.network(
                                    snapshot.data?[index].strCategoryThumb ?? '',
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text(
                                    snapshot.data?[index].strCategory ?? '',
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
            ),
          ],
        ),
      ),
    );
  }
}
