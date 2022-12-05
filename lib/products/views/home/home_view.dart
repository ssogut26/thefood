import 'dart:async';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:go_router/go_router.dart';
import 'package:kartal/kartal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thefood/core/constants/assets_path.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/endpoints.dart';
import 'package:thefood/core/constants/paddings.dart';
import 'package:thefood/core/constants/texts.dart';
import 'package:thefood/core/services/search_service.dart';
import 'package:thefood/features/components/loading.dart';
import 'package:thefood/features/components/widgets.dart';
import 'package:thefood/products/models/categories.dart';
import 'package:thefood/products/models/meals.dart';
import 'package:thefood/products/views/home/cubit/bloc/home_cubit.dart';

part '../../view_models/home_shimmers_view_model.dart';
part '../../view_models/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    dataLength = 0;
    selectedIndex = 0;
    itemLength();
    isLoading = changeLoading();
    super.initState();
  }

  bool isLoading = true;

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
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        final connected = connectivity != ConnectivityResult.none;
        return isLoading
            ? _loadingAnim(isLoading)
            : connected == true
                ? _homeBody()
                : _noConnection();
      },
      child: _noConnectionText(),
    );
  }
}
