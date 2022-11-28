extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String deleteParentheses() {
    return substring(1, length - 1);
  }
}
