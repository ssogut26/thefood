import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/hive_constants.dart';
import 'package:thefood/constants/text_styles.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/firebase_options.dart';
import 'package:thefood/services/home_service.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/views/auth/forgot_password_view.dart';
import 'package:thefood/views/auth/login_view.dart';
import 'package:thefood/views/auth/singup_view.dart';
import 'package:thefood/views/category_details/category_details_view.dart';
import 'package:thefood/views/details/details_view.dart';
import 'package:thefood/views/favorites/favorite_view.dart';
import 'package:thefood/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/views/home/home_view.dart';
import 'package:thefood/views/home/navigator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>(HiveConstants.loginCredentials);
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
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
      title: ProjectTexts.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: ProjectColors.mainWhite,
        useMaterial3: true,
        textTheme: ProjectTextStyles().textTheme,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
    initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const NavigatorView();
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
          return DetailsView(
            name: name,
            image: image,
            id: id,
          );
        },
      ),
      GoRoute(
        path: '/singup',
        name: 'singup',
        builder: (BuildContext context, GoRouterState state) {
          return const SingUpView();
        },
      ),
      GoRoute(
        path: '/navigator',
        name: 'navigator',
        builder: (BuildContext context, GoRouterState state) {
          return const NavigatorView();
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
}
