import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.recipe,
    this.favorite,
  });

  final String? email;

  final String id;

  final String? name;

  final List<String>? recipe;

  final List<String>? favorite;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, recipe, favorite];
}
