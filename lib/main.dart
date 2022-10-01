import 'package:flutter/material.dart';
import 'package:thefood/constants/text_styles.dart';
import 'package:thefood/views/home_view.dart';

void main() {
  runApp(const TheFood());
}

class TheFood extends StatefulWidget {
  const TheFood({super.key});

  @override
  State<TheFood> createState() => _TheFoodState();
}

class _TheFoodState extends State<TheFood> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'theFood',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: ProjectTextStyles().textTheme,
      ),
      home: const HomeView(),
    );
  }
}
