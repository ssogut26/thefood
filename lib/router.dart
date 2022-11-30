part of 'main.dart';

final GoRouter _router = GoRouter(
  routerNeglect: true,
  errorBuilder: (context, error) => Scaffold(
    body: Center(
      child: Text(error.toString()),
    ),
  ),
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/',
      name: '/',
      builder: (BuildContext context, GoRouterState state) {
        return NavigatorView(
          widgetOptions: [
            BlocProvider(
              create: (_) => ProfileCubit(),
              child: const ProfileView(),
            ),
            BlocProvider(
              create: (context) => HomeCubit(
                HomeService(
                  NetworkManager.instance,
                ),
              ),
              child: const HomeView(),
            ),
            BlocProvider(
              create: (context) => FavoritesCubit(),
              child: const FavoriteView(),
            ),
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
      path: '/loading',
      name: 'loading',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashView();
      },
    ),
    GoRoute(
      path: '/onboard',
      name: 'onboard',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardView();
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
    ),
    GoRoute(
      path: '/add',
      name: 'add',
      builder: (BuildContext context, GoRouterState state) {
        return const AddRecipe();
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => ProfileCubit(),
          child: const ProfileView(),
        );
      },
    ),
  ],
);
