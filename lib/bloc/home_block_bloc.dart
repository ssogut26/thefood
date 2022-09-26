import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_block_event.dart';
part 'home_block_state.dart';

class HomeBlockBloc extends Bloc<HomeBlockEvent, HomeBlockState> {
  HomeBlockBloc() : super(HomeBlockInitial()) {
    on<HomeBlockEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
