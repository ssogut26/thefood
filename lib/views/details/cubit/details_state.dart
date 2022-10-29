part of 'details_cubit.dart';

class DetailsState extends Equatable {
  DetailsState({
    required this.id,
    this.meal,
    this.favoriteMealDetail,
    this.detailService,
  });

  final int id;
  final Meal? meal;
  late Meal? favoriteMealDetail;
  final IDetailService? detailService;

  @override
  List<Object?> get props => [id, meal, favoriteMealDetail, detailService];

  DetailsState copyWith({
    int? id,
    Meal? meal,
    Meal? favoriteMealDetail,
    IDetailService? detailService,
  }) {
    return DetailsState(
      id: id ?? this.id,
      meal: meal ?? this.meal,
      favoriteMealDetail: favoriteMealDetail ?? this.favoriteMealDetail,
      detailService: detailService ?? this.detailService,
    );
  }
}
