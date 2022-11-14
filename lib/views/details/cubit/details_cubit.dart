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
    getUserRecipe(id);
  }

  final IDetailService detailService;
  final ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  final int id;
  Map<String, dynamic>? userRecipe;
  Meal? favoriteMealDetail;
  final BuildContext context;

  Future<Meal?> getMeal(int id) async {
    final mealDetail = await detailService.getMeal(id);
    emit(
      state.copyWith(
        meal: mealDetail,
      ),
    );
    return mealDetail;
  }

  Future<Map<String, dynamic>?> getUserRecipe(int id) async {
    state.userRecipe = await detailService.isUserRecipe(id);
    userRecipe = await detailService.isUserRecipe(id);
    emit(
      state.copyWith(
        userRecipe: userRecipe,
      ),
    );
    return state.userRecipe;
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
