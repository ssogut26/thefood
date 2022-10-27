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
  ) : super(const DetailsState()) {
    getMeal(id);
  }
  final IDetailService detailService;
  final int id;
  final ICacheManager<Meal> favoriteCacheManager;
  Meal? favoriteMealDetail;

  Future<Meal?> getMeal(int id) async {
    final mealDetails = await detailService.getMeal(id);
    emit(state.copyWith(meal: mealDetails));
    return mealDetails!;
  }

  Future<void> fetchData() async {
    await favoriteCacheManager.init();
    if (favoriteCacheManager.getItem('id')?.meals?.isNotEmpty ?? false) {
      favoriteMealDetail = favoriteCacheManager.getItem('id');
    } else {
      favoriteMealDetail = null;
    }
  }
}
