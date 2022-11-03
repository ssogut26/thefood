part of 'main.dart';

final GoRouter _router = GoRouter(
  routerNeglect: true,
  errorBuilder: (context, error) => Scaffold(
    body: Center(
      child: Text(error.toString()),
    ),
  ),
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const NavigatorView(
          widgetOptions: [
            HomeView(),
            HomeView(),
            FavoriteView(),
          ],
        );
      },
      routes: [
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => HomeCubit(HomeService(NetworkManager.instance)),
              child: const HomeView(),
            );
          },
        ),
        GoRoute(
          path: 'favorites',
          name: 'favorites',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => FavoritesCubit(),
              child: const FavoriteView(),
            );
          },
        ),
      ],
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
      path: '/details/:id/:name/:image',
      name: 'details',
      builder: (BuildContext context, GoRouterState state) {
        final name = state.params['name'] ?? '';
        final image = state.params['image'] ?? '';
        final id = int.parse(state.params['id'] ?? '');
        return BlocProvider(
          create: (context) => DetailsCubit(
            DetailService(NetworkManager.instance),
            id,
            context,
          ),
          child: DetailsView(
            name: name,
            image: image,
            id: id,
          ),
        );
      },
    ),
    GoRoute(
      path: '/singup',
      name: 'singup',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => SignUpCubit(AuthenticationRepository()),
          child: const SingUpView(),
        );
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => LoginCubit(AuthenticationRepository()),
          child: const LoginView(),
        );
      },
    ),
    GoRoute(
      path: '/forgot',
      name: 'forgot',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPassView();
      },
    )
  ],
);
