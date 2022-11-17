import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/core/services/managers/cache_manager.dart';
import 'package:thefood/features/compoments/models/meals.dart';

part 'favorite_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit()
      : super(
          FavoritesState(),
        ) {
    fetchListOfFavorites();
    removeItem('');
    checkUpdated();
  }

  final ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  List<Meal>? favoriteBox;

  Future<void> fetchListOfFavorites() async {
    await favoriteCacheManager.init();
    if (favoriteCacheManager.getValues()?.isNotEmpty ?? false) {
      favoriteBox = favoriteCacheManager.getValues();
    }
    emit(
      state.copyWith(
        favoriteBox: favoriteBox,
      ),
    );
  }

  Stream<void> checkUpdated() async* {
    if (favoriteBox?.length != favoriteCacheManager.getValues()?.length) {
      favoriteBox = favoriteCacheManager.getValues();
    }
    emit(
      state.copyWith(
        favoriteBox: favoriteBox,
      ),
    );
  }

  Future<void Function()?> removeItem(String key) async {
    await favoriteCacheManager.removeItem(key);
    favoriteBox = favoriteCacheManager.getValues();
    emit(
      state.copyWith(
        favoriteBox: favoriteBox,
      ),
    );
    return null;
  }

  Future<void> Function() onRefresh() {
    return () async {
      await Future.delayed(const Duration(seconds: 1));
      await fetchListOfFavorites();
    };
  }
}
