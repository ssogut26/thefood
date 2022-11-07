import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/constants/paddings.dart';
import 'package:thefood/models/categories.dart';
import 'package:thefood/services/managers/network_manager.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  late Future<List<MealCategory>?> categories;
  late int index;

  @override
  void initState() {
    index = 0;
    categories = NetworkManager.instance.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: Padding(
        padding: ProjectPaddings.pageLarge,
        child: Column(
          children: [
            Padding(
              padding: ProjectPaddings.cardMedium,
              child: SizedBox(
                width: context.width,
                height: context.height * 0.05,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.yellow[200],
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CATEGORY',
                      style: context.textTheme.headline2,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder<List<MealCategory>?>(
              future: categories,
              builder: (context, snapshot) {
                for (var index = 0; index < snapshot.data!.length; index++) {
                  return Text(snapshot.data?[index].strCategory ?? '');
                }
                return DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(
                      value: snapshot.data?[index].strCategory,
                      child: Text(snapshot.data?[index].strCategory ?? ''),
                    ),
                    const DropdownMenuItem(
                      value: 'Lunch',
                      child: Text('Lunch'),
                    ),
                    const DropdownMenuItem(
                      value: 'Dinner',
                      child: Text('Dinner'),
                    ),
                    const DropdownMenuItem(
                      value: 'Dessert',
                      child: Text('Dessert'),
                    ),
                  ],
                  onChanged: (value) {
                    // setState(() {
                    //   // _selectedCategory = value;
                    // });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
