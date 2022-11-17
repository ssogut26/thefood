import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navigator/navigator.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/hive_constants.dart';
import 'package:thefood/core/constants/text_styles.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/detail_service.dart';
import 'package:thefood/core/services/home_service.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/features/compoments/views/add_recipe/add_recipe_view.dart';
import 'package:thefood/features/compoments/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/features/compoments/views/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:thefood/features/compoments/views/auth/forgot_password_view.dart';
import 'package:thefood/features/compoments/views/auth/login_view.dart';
import 'package:thefood/features/compoments/views/auth/singup_view.dart';
import 'package:thefood/features/compoments/views/category_details/category_details_view.dart';
import 'package:thefood/features/compoments/views/details/cubit/details_cubit.dart';
import 'package:thefood/features/compoments/views/details/details_view.dart';
import 'package:thefood/features/compoments/views/favorites/cubit/favorite_cubit.dart';
import 'package:thefood/features/compoments/views/favorites/favorite_view.dart';
import 'package:thefood/features/compoments/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/features/compoments/views/home/home_view.dart';
import 'package:thefood/features/compoments/views/profile/profile_view.dart';
import 'package:thefood/firebase_options.dart';

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
