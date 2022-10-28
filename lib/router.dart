part of 'main.dart';

final GoRouter _router = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const NavigatorView(
          widgetOptions: [
            HomeView(),
            HomeView(),
            FavoriteView(),
          ],
        );
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
      path: '/home',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (_) => HomeCubit(HomeService(NetworkManager.instance)),
          child: const HomeView(),
        );
      },
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (BuildContext context, GoRouterState state) {
        return const FavoriteView();
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
            FavoriteMealDetailCacheManager('mealDetails'),
            DetailService(NetworkManager.instance),
            id,
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
      path: '/navigator',
      name: 'navigator',
      builder: (BuildContext context, GoRouterState state) {
        return const NavigatorView(
          widgetOptions: [
            HomeView(),
            HomeView(),
            FavoriteView(),
          ],
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
