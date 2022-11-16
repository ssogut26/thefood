part of 'details_cubit.dart';

class DetailsState extends Equatable {
  DetailsState({
    required this.id,
    this.meal,
    this.favoriteMealDetail,
    this.detailService,
    this.userRecipe,
    this.connectionStatus,
  });

  final int id;
  final Meal? meal;
  late Meal? favoriteMealDetail;
  late Map<String, dynamic>? userRecipe;
  final IDetailService? detailService;
  final ConnectivityResult? connectionStatus;

  @override
  List<Object?> get props => [id, userRecipe, meal, favoriteMealDetail, detailService];

  DetailsState copyWith({
    int? id,
    Map<String, dynamic>? userRecipe,
    Meal? meal,
    Meal? favoriteMealDetail,
    IDetailService? detailService,
    ConnectivityResult? connectionStatus,
  }) {
    return DetailsState(
      id: id ?? this.id,
      userRecipe: userRecipe ?? this.userRecipe,
      meal: meal ?? this.meal,
      favoriteMealDetail: favoriteMealDetail ?? this.favoriteMealDetail,
      detailService: detailService ?? this.detailService,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}
