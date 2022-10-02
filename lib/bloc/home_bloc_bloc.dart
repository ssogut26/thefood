import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/ingredients.dart';

part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  HomeBloc({required Dio dio})
      : _dio = dio,
        super(const HomeBlocState()) {
    on<FetchedData>(_onFetchedData);
  }
  final Dio _dio;

  void _onFetchedData(FetchedData event, Emitter<HomeBlocState> emit) {
    if (state.hasReachedMax) return;
    if (state.status == HomeBlockStatus.initial) {
      getIngredients();
    } else if (state.status == HomeBlockStatus.success) {
      getIngredients();
    }
  }

  Future<Ingredients?> getIngredients() async {
    final response = await _dio.get(EndPoints().listByIngredients);
    if (response.statusCode == 200) {
      final ingredients = response.data;
      if (ingredients is Map<String, dynamic>) {
        return Ingredients.fromJson(ingredients);
      }
    }
    return null;
  }
}
