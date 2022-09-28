// create test

import 'package:flutter_test/flutter_test.dart';
import 'package:thefood/services/network_manager.dart';

void main() {
  test('getCategories', () async {
    final categories = await NetworkManager.instance.getCategories();
    expect(categories, isNotNull);
  });
}
