import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thefood/core/services/category_meal_service.dart';
import 'package:thefood/core/services/detail_service.dart';
import 'package:thefood/core/services/home_service.dart';
import 'package:thefood/core/services/managers/network_manager.dart';
import 'package:thefood/products/views/auth/bloc/login/login_cubit.dart';
import 'package:thefood/products/views/auth/bloc/sign_up/sign_up_cubit.dart';
import 'package:thefood/products/views/category_details/cubit/category_details_cubit.dart';
import 'package:thefood/products/views/details/cubit/details_cubit.dart';
import 'package:thefood/products/views/favorites/cubit/favorite_cubit.dart';
import 'package:thefood/products/views/home/cubit/bloc/home_cubit.dart';
import 'package:thefood/products/views/profile/cubit/profile_cubit.dart';

class Providers extends StatelessWidget {
  const Providers({
    super.key,
    required this.child,
  });

  final Widget child;

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
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
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
        BlocProvider(
          create: (context) => CategoryDetailsCubit(
            CategoryMealService(
              NetworkManager.instance,
            ),
          ),
        ),
      ],
      child: child,
    );
  }
}
