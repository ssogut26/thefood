import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/views/favorites/cubit/favorite_cubit.dart';

part '../../view_models/favorite_view_model.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  @override
  void initState() {
    isLoading = changeLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CustomLottieLoading(
              onLoaded: (composition) {
                isLoading = false;
              },
            ),
          )
        : Scaffold(
            appBar: _appBar(context),
            body: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                return context.watch<FavoritesCubit>().favoriteBox?.isNotEmpty ?? false
                    ? const AllFavorites()
                    : const PullToRefresh();
              },
            ),
          );
  }
}
