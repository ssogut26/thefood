part of 'favorite_cubit.dart';

class FavoritesState extends Equatable {
  FavoritesState({
    this.favoriteBox,
    this.isLoading = false,
  });

  late List<Meal?>? favoriteBox;
  bool? isLoading;

  @override
  List<Object?> get props => [favoriteBox];

  FavoritesState copyWith({
    List<Meal?>? favoriteBox,
    bool? isLoading,
  }) {
    return FavoritesState(
      favoriteBox: favoriteBox ?? this.favoriteBox,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
