import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navigator/navigator.dart';
import 'package:thefood/constants/colors.dart';
import 'package:thefood/constants/hive_constants.dart';
import 'package:thefood/constants/text_styles.dart';
import 'package:thefood/constants/texts.dart';
import 'package:thefood/firebase_options.dart';
import 'package:thefood/services/detail_service.dart';
import 'package:thefood/services/home_service.dart';
import 'package:thefood/services/managers/network_manager.dart';
import 'package:thefood/views/add_recipe/add_recipe_view.dart';
import 'package:thefood/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/views/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:thefood/views/auth/forgot_password_view.dart';
import 'package:thefood/views/auth/login_view.dart';
import 'package:thefood/views/auth/singup_view.dart';
import 'package:thefood/views/category_details/category_details_view.dart';
import 'package:thefood/views/details/cubit/details_cubit.dart';
import 'package:thefood/views/details/details_view.dart';
import 'package:thefood/views/favorites/cubit/favorite_cubit.dart';
import 'package:thefood/views/favorites/favorite_view.dart';
import 'package:thefood/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/views/home/home_view.dart';
import 'package:thefood/views/profile/profile_view.dart';

part 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final directory = await pathProvider.getApplicationDocumentsDirectory();
  // Hive.init(directory.path);

  await Hive.openBox<String>(HiveConstants.loginCredentials);
  final userbox = await Hive.openBox<String>(HiveConstants.user);
  final currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';
  await userbox.add(currentUser);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            HomeService(
              NetworkManager.instance,
            ),
          ),
        ),
        BlocProvider<DetailsCubit>(
          create: (context) => DetailsCubit(
            DetailService(
              NetworkManager.instance,
            ),
            0,
            context,
          ),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => FavoritesCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(
            AuthenticationRepository(),
          ),
        ),
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(
            AuthenticationRepository(),
          ),
        ),
      ],
      child: MaterialApp.router(
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
      ),
    );
  }
}
