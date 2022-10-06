class EndPoints {
  EndPoints._();
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  static const String categories = 'categories.php';
  static const String listByCategories = 'list.php?c=list';
  static const String listByArea = 'list.php?a=list';
  static const String listByIngredients = 'list.php?i=list';
  static const String filterByMainIngredients = 'filter.php?i=';
  static const String filterByCategory = 'filter.php?c=';
  static const String filterByArea = 'filter.php?a=';
  static const String getMealDetail = 'lookup.php?i=';
  static const String randomMeal = 'random.php';
  static const String ingredientsImages = 'https://www.themealdb.com/images/ingredients/';
}
