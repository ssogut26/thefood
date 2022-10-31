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

  Future<void> checkUpdated() async {
    if (favoriteBox != favoriteCacheManager.getValues()) {
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
}
