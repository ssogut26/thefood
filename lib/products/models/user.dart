import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModels extends Equatable {
  const UserModels({
    this.id,
    this.email,
    this.name,
    this.country,
    this.photoURL,
  });
  factory UserModels.fromJson(Map<String, dynamic> json) => _$UserModelsFromJson(json);
  factory UserModels.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      _$UserModelsFromFirestore(doc);

  Map<String, dynamic> toFirestore() => _$UserModelsToFirebase(this);
  Map<String, dynamic> toJson() => _$UserModelsToJson(this);

  final String? email;

  final String? id;

  final String? name;

  final String? country;

  final String? photoURL;

  static const empty = UserModels(id: '');

  bool get isEmpty => this == UserModels.empty;

  bool get isNotEmpty => this != UserModels.empty;

  @override
  List<Object?> get props => [email, id, name, country, photoURL];
}
