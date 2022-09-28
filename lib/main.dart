import 'package:flutter/material.dart';
import 'package:thefood/models/category.dart';
import 'package:thefood/services/network_manager.dart';

void main() {
  runApp(const TheFood());
}

class TheFood extends StatefulWidget {
  const TheFood({super.key});

  @override
  State<TheFood> createState() => _TheFoodState();
}

class _TheFoodState extends State<TheFood> {
  late final Future<List<MealCategory>?> categories;

  @override
  void initState() {
    categories = NetworkManager.instance.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'theFood',
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
