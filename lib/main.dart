import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/text_styles.dart';
import 'package:thefood/views/category_details/category_details_view.dart';
import 'package:thefood/views/details/details_view.dart';
import 'package:thefood/views/home/home_view.dart';

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
    return MaterialApp.router(
      title: 'theFood',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: ProjectTextStyles().textTheme,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: ProjectColors.white),
          elevation: 0,
        ),
        cardTheme: const CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeView();
        },
      ),
      GoRoute(
        path: '/category/:name/:image',
        name: 'category',
        builder: (BuildContext context, GoRouterState state) {
          final name = state.params['name'] ?? '';
          final image = state.params['image'] ?? '';
          return CategoryDetailsView(
            name: name,
            image: image,
          );
        },
      ),
      GoRoute(
        path: '/details/:name/:image',
        name: 'details',
        builder: (BuildContext context, GoRouterState state) {
          final name = state.params['name'] ?? '';
          final image = state.params['image'] ?? '';
          final id = int.parse(state.params['id'] ?? '');
          return DetailsView(
            id: id,
            name: name,
            image: image,
          );
        },
      )
    ],
  );
}
