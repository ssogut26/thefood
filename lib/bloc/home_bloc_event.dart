part of 'home_bloc_bloc.dart';

@immutable
abstract class HomeBlocEvent extends Equatable {
  const HomeBlocEvent();

  @override
  List<Object> get props => [];
}

@immutable
class FetchedData extends HomeBlocEvent {
  const FetchedData();
}
