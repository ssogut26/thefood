// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModels _$UserModelsFromJson(Map<String, dynamic> json) => UserModels(
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      favorite: json['favorite'] as List<dynamic>?,
      image: json['image'] as String?,
    );

UserModels _$UserModelsFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
    UserModels(
      id: doc.id,
      email: doc.data()?['email'] as String?,
      name: doc.data()?['name'] as String?,
      favorite: doc.data()?['favorite'] as List<dynamic>?,
      image: doc.data()?['image'] as String?,
    );

Map<String, dynamic> _$UserModelsToJson(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'name': instance.name,
      'favorite': instance.favorite,
      'image': instance.image,
    };

Map<String, dynamic> _$UserModelsToFirebase(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'name': instance.name,
      'favorite': instance.favorite,
      'image': instance.image,
    };
