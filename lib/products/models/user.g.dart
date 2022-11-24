// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModels _$UserModelsFromJson(Map<String, dynamic> json) => UserModels(
      userId: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      photoURL: json['image'] as String?,
    );

UserModels _$UserModelsFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
    UserModels(
      userId: doc.id,
      email: doc.data()?['email'] as String?,
      name: doc.data()?['name'] as String?,
      country: doc.data()?['country'] as String?,
      photoURL: doc.data()?['image'] as String?,
    );

Map<String, dynamic> _$UserModelsToJson(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'userId': instance.userId,
      'name': instance.name,
      'country': instance.country,
      'photoURL': instance.photoURL,
    };

Map<String, dynamic> _$UserModelsToFirebase(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'userId': instance.userId,
      'name': instance.name,
      'country': instance.country,
      'photoURL': instance.photoURL,
    };
