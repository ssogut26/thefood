import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/constants/flags.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/managers/cache_manager.dart';
import 'package:thefood/features/components/alerts.dart';
import 'package:thefood/features/components/extensions.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/features/components/widgets.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/views/details/cubit/details_cubit.dart';
import 'package:timeago/timeago.dart' as TimeAgo;
import 'package:url_launcher/url_launcher.dart';

part '../../view_models/details_view_model.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({
    this.image,
    required this.id,
    super.key,
    this.name,
  });
  final String? image;
  final String? name;
  final int id;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  bool isLoading = true;
  late bool isUserRecipe;

  bool checkUserRecipe() {
    if (isUserRecipe = widget.id < 50000) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    isUserRecipe = checkUserRecipe();
    isLoading = changeLoading();
    super.initState();
  }

  bool changeLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
    return isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final connected = connectivity != ConnectivityResult.none;
          return isLoading
              ? Center(
                  child: CustomLottieLoading(
                    onLoaded: (composition) {
                      isLoading = false;
                    },
                  ),
                )
              : CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: <Widget>[
                    RecipeImage(connected: connected, widget: widget),
                    DetailsBody(connected: connected, isUserRecipe: isUserRecipe),
                  ],
                );
        },
        child: Center(
          child: CustomLottieLoading(
            path: AssetsPath.progression,
            onLoaded: (composition) {},
          ),
        ),
      ),
    );
  }
}
