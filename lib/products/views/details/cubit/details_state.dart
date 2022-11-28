part of 'details_cubit.dart';

class DetailsState extends Equatable {
  DetailsState({
    required this.id,
    this.meal,
    this.favoriteMealDetail,
    this.detailService,
    this.userRecipe,
    this.comments,
    this.selectedIndex,
    this.connectionStatus,
  });

  final int id;
  final Meal? meal;
  late Meal? favoriteMealDetail;
  final String? comments;
  late Map<String, dynamic>? userRecipe;
  final int? selectedIndex;
  final IDetailService? detailService;
  final ConnectivityResult? connectionStatus;

  @override
  List<Object?> get props =>
      [id, userRecipe, meal, selectedIndex, comments, favoriteMealDetail, detailService];

  DetailsState copyWith({
    int? id,
    Map<String, dynamic>? userRecipe,
    Meal? meal,
    String? comments,
    Meal? favoriteMealDetail,
    int? selectedIndex,
    IDetailService? detailService,
    ConnectivityResult? connectionStatus,
  }) {
    return DetailsState(
      id: id ?? this.id,
      userRecipe: userRecipe ?? this.userRecipe,
      comments: comments ?? this.comments,
      meal: meal ?? this.meal,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      favoriteMealDetail: favoriteMealDetail ?? this.favoriteMealDetail,
      detailService: detailService ?? this.detailService,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }
}
