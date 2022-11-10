// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:thefood/models/ingredients.dart';
// import 'package:thefood/services/managers/network_manager.dart';

// part 'search_state.dart';

// class SearchCubit extends Cubit<SearchState> {
//   SearchCubit(NetworkManager service) : super(SearchLoading()) {
//   _service = service;

//   }
//   late final NetworkManager _service;

//   late Ingredients _ingredients;

//   Future<void> fetchAllIngredients() async {
//     final response = await _service.getIngredients();
//     if (response != null) {
//       _ingredients = response;
//       emit(SearchLoaded(response));
//     }else {
//       emit(SearchError());
//     }
//   }

//   Future<void> findIngredient(String key) {
//     final response = await compute.(MultiThread)
//   }
// }
