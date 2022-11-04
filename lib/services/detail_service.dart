import 'package:thefood/constants/endpoints.dart';
import 'package:thefood/models/meals.dart';
import 'package:thefood/services/managers/network_manager.dart';

abstract class IDetailService {
  IDetailService(NetworkManager networkManager) : _networkManager = networkManager;
  late final NetworkManager _networkManager;
  Future<Meal?> getMeal(int id);
}

class DetailService extends IDetailService {
  DetailService(super.networkManager);

  @override
  Future<Meal?> getMeal(int id) async {
    final response = await _networkManager.service.get('${EndPoints.getMealDetail}$id');
    if (response.statusCode == 200) {
      final meals = response.data;
      if (meals is Map<String, dynamic>) {
        return Meal.fromJson(meals);
      }
    }
    return null;
  }
}