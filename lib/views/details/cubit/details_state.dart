part of 'details_cubit.dart';

class DetailsState extends Equatable {
  DetailsState({
    this.id,
    this.meal,
    this.favoriteMealDetail,
    this.favoriteCacheManager,
    this.detailService,
  });
  final int? id;
  final Meal? meal;
  Meal? favoriteMealDetail;
  final ICacheManager<Meal>? favoriteCacheManager;
  final IDetailService? detailService;

  @override
  List<Object?> get props =>
      [id, meal, favoriteMealDetail, favoriteCacheManager, detailService];

  DetailsState copyWith({
    int? id,
    Meal? meal,
    Meal? favoriteMealDetail,
    ICacheManager<Meal>? favoriteCacheManager,
    IDetailService? detailService,
  }) {
    return DetailsState(
      id: id ?? this.id,
      meal: meal ?? this.meal,
      favoriteMealDetail: favoriteMealDetail ?? this.favoriteMealDetail,
      favoriteCacheManager: favoriteCacheManager ?? this.favoriteCacheManager,
      detailService: detailService ?? this.detailService,
    );
  }
}
