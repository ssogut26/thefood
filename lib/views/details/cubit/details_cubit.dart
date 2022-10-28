import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/detail_service.dart';
import 'package:thefood/services/managers/cache_manager.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(
    this.favoriteCacheManager,
    this.detailService,
    this.id,
  ) : super(DetailsState()) {
    getMeal(state.id ?? 0);
    fetchData();
    updateId(state.id ?? 0);
  }
  final IDetailService detailService;

  ICacheManager<Meal> favoriteCacheManager =
      FavoriteMealDetailCacheManager('mealDetails');
  Meal? favoriteMealDetail;
  int id = 0;

  Future<Meal?> getMeal(int id) async {
    final mealDetails = await detailService.getMeal(id);
    emit(state.copyWith(meal: mealDetails));
    return mealDetails!;
  }

  void updateId(int id) {
    emit(state.copyWith(id: id));
  }

  Future<void> fetchData() async {
    await favoriteCacheManager.init();
    if (favoriteCacheManager.getItem(state.id.toString())?.meals?.isNotEmpty ?? false) {
      state.favoriteMealDetail = favoriteCacheManager.getItem(state.id.toString());
    } else {
      state.favoriteMealDetail = await detailService.getMeal(state.id ?? 0);
    }
    emit(state.copyWith(meal: state.favoriteMealDetail));
  }
}
