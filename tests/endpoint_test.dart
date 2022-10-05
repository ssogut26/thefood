import 'package:flutter_test/flutter_test.dart';
import 'package:thefood/services/network_manager.dart';

void main() {
  test('getCategories', () async {
    final categories = await NetworkManager.instance.getCategories();
    expect(categories, isNotNull);
  });

  test('getByArea', () async {
    final areas = await NetworkManager.instance.getAreas();
    expect(areas, isNotEmpty);
  });
  test('getByArea', () async {
    final area = await NetworkManager.instance.getMealsByCategory('American');
    expect(area, isNotEmpty);
  });
}
