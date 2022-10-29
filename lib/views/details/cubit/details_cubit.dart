import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/detail_service.dart';
import 'package:thefood/services/managers/cache_manager.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this.detailService, this.id)
      : super(
          DetailsState(id: id),
        ) {
    getMeal(id);
    fetchMealData(id);
    updateId(id);
  }

  final IDetailService detailService;
  final ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  final int id;
  Meal? favoriteMealDetail;

  Future<Meal?> getMeal(int id) async {
    final mealDetail = await detailService.getMeal(id);
    emit(
      state.copyWith(
        meal: mealDetail,
      ),
    );
    return mealDetail;
  }

  void updateId(int id) {
    emit(
      state.copyWith(
        id: id,
      ),
    );
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
