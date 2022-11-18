import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thefood/core/services/detail_service.dart';
import 'package:thefood/core/services/managers/cache_manager.dart';
import 'package:thefood/products/models/meals.dart';

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

  int changeSelectedIndex() {
    if (state.selectedIndex == 0) {
      emit(
        state.copyWith(
          selectedIndex: 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          selectedIndex: 1,
        ),
      );
    }
    return state.selectedIndex ?? 0;
  }

  Future<void> fetchMealData(int id) async {
    await favoriteCacheManager.init();
    final userRecipeResponse = await detailService.isUserRecipe(id);
    final mealDetail = await detailService.getMeal(id);
    if (state.id == id) {
      if (favoriteCacheManager.getItem(id.toString())?.meals?.isNotEmpty ?? false) {
        favoriteMealDetail = favoriteCacheManager.getItem(id.toString());
      } else if (userRecipeResponse.isNotEmpty) {
        favoriteMealDetail = Meal(
          meals: [
            Meals().copyWith(
              idMeal: userRecipeResponse['idMeal'] as String?,
              strMeal: userRecipeResponse['strMeal'] as String?,
              strMealThumb: userRecipeResponse['strMealThumb'] as String?,
              strInstructions: userRecipeResponse['strInstructions'] as String?,
              strYoutube: userRecipeResponse['strYoutube'] as String?,
              strSource: userRecipeResponse['strSource'] as String?,
              strArea: userRecipeResponse['strArea'] as String?,
              strCategory: userRecipeResponse['strCategory'] as String?,
              strTags: userRecipeResponse['strTags'] as String?,
              strIngredients: (userRecipeResponse['strIngredients'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList(),
              strMeasures: (userRecipeResponse['strMeasures'] as List<dynamic>)
                  .map((e) => e as String)
                  .toList(),
            )
          ],
        );
      } else {
        favoriteMealDetail = await detailService.getMeal(id);
      }
      emit(state.copyWith(favoriteMealDetail: favoriteMealDetail));
    }
  }
}
