part of 'favorite_cubit.dart';

class FavoritesState extends Equatable {
  FavoritesState({
    this.favoriteBox,
  });

  late List<Meal?>? favoriteBox;

  @override
  List<Object?> get props => [favoriteBox];

  FavoritesState copyWith({
    List<Meal?>? favoriteBox,
  }) {
    return FavoritesState(
      favoriteBox: favoriteBox ?? this.favoriteBox,
    );
  }
}
