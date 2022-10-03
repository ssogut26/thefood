import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thefood/constants/text_styles.dart';
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
        path: '/details/:name/:image',
        name: 'details',
        builder: (BuildContext context, GoRouterState state) {
          final name = state.params['name'] ?? '';
          final image = state.params['image'] ?? '';
          return DetailsView(
            name: name,
            image: image,
          );
        },
      ),
    ],
  );
}
