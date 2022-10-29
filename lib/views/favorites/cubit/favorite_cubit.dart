import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/cache_manager.dart';

part 'favorite_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit()
      : super(
          FavoritesState(),
        ) {
    fetchData();
  }

  ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  List<Meal?>? favoriteBox;

  Future<void> fetchData() async {
    await favoriteCacheManager.init();
    if (favoriteCacheManager.getValues()?.isNotEmpty ?? false) {
      favoriteBox = favoriteCacheManager.getValues();
    }
    emit(state.copyWith(favoriteBox: favoriteBox));
  }

  Future<void> removeItem(String key) async {
    await favoriteCacheManager.removeItem(key);
    emit(state.copyWith(favoriteBox: favoriteBox));
    await fetchData();
  }
}
