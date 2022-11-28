import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModels extends Equatable {
  const UserModels({
    this.userId,
    this.email,
    this.name,
    this.country,
    this.photoURL,
  });
  factory UserModels.fromJson(Map<String, dynamic> json) => _$UserModelsFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelsToJson(this);

  final String? email;

  final String? userId;

  final String? name;

  final String? country;

  final String? photoURL;

  static const empty = UserModels(userId: '');

  bool get isEmpty => this == UserModels.empty;

  bool get isNotEmpty => this != UserModels.empty;

  @override
  List<Object?> get props => [email, userId, name, country, photoURL];
}
