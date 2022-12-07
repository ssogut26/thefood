import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navigator/navigator.dart';
import 'package:thefood/core/constants/hive_constants.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/detail_service.dart';
import 'package:thefood/core/services/home_service.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/firebase_options.dart';
import 'package:thefood/products/views/add_recipe/add_recipe_view.dart';
import 'package:thefood/products/views/add_recipe/cubit/add_recipe_cubit.dart';
import 'package:thefood/products/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/products/views/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:thefood/products/views/auth/forgot_password_view.dart';
import 'package:thefood/products/views/auth/login_view.dart';
import 'package:thefood/products/views/auth/signup_view.dart';
import 'package:thefood/products/views/category_details/category_details_view.dart';
import 'package:thefood/products/views/details/cubit/details_cubit.dart';
import 'package:thefood/products/views/details/details_view.dart';
import 'package:thefood/products/views/favorites/cubit/favorite_cubit.dart';
import 'package:thefood/products/views/favorites/favorite_view.dart';
import 'package:thefood/products/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/products/views/home/home_view.dart';
import 'package:thefood/products/views/onboard/onboard_view.dart';
import 'package:thefood/products/views/page_loading/page_loading_view.dart';
import 'package:thefood/products/views/profile/cubit/profile_cubit.dart';
import 'package:thefood/products/views/profile/profile_view.dart';
import 'package:thefood/ui/theme.dart';

part 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final pathProvider = PathProvider();
  // final directory = await pathProvider.getApplicationDocumentsDirectory();
  // Hive.init(directory.path);
  await Hive.openBox<String>(HiveConstants.loginCredentials);
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;
  runApp(
    const ProviderScope(child: TheFood()),
  );
}

class TheFood extends StatefulWidget {
  const TheFood({super.key});

  @override
  State<TheFood> createState() => _TheFoodState();
}

class _TheFoodState extends State<TheFood> {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: ProjectTexts.appName,
      theme: ProjectTheme().lightTheme,
      routerConfig: _router,
    );
  }
}
