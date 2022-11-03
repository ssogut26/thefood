import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/detail_service.dart';
import 'package:thefood/services/managers/cache_manager.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this.detailService, this.id, this.context)
      : super(
          DetailsState(id: id),
        ) {
    getMeal(id);
    fetchMealData(id);
  }

  final IDetailService detailService;
  final ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  final int id;
  Meal? favoriteMealDetail;
  final BuildContext context;
  late ConnectivityResult connectionStatus;

  Future<Meal?> getMeal(int id) async {
    final mealDetail = await detailService.getMeal(id);
    emit(
      state.copyWith(
        meal: mealDetail,
      ),
    );
    return mealDetail;
  }

  Future<void> fetchMealData(int id) async {
    await favoriteCacheManager.init();
    if (state.id == id) {
      if (favoriteCacheManager.getItem(id.toString())?.meals?.isNotEmpty ?? false) {
        favoriteMealDetail = favoriteCacheManager.getItem(id.toString());
      } else {
        favoriteMealDetail = await detailService.getMeal(id);
      }
    }
    emit(state.copyWith(favoriteMealDetail: favoriteMealDetail));
  }
}

enum Status {
  none(ConnectivityResult.none),
  wifi(ConnectivityResult.wifi),
  mobile(ConnectivityResult.mobile);

  const Status(this.connectionStatus);
  final ConnectivityResult? connectionStatus;
}
