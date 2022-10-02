part of 'home_bloc_bloc.dart';

enum HomeBlockStatus { initial, loading, success, failure }

class HomeBlocState extends Equatable {
  const HomeBlocState({
    this.ingredients = const <Ingredients>[],
    this.hasReachedMax = false,
    this.status = HomeBlockStatus.initial,
  });

  final List<Ingredients?> ingredients;

  final bool hasReachedMax;

  final HomeBlockStatus status;

  @override
  List<Object> get props => [ingredients, hasReachedMax, status];
}

class HomeBlockInitial extends HomeBlocState {
  const HomeBlockInitial();
}
