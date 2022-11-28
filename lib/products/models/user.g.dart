// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModels _$UserModelsFromJson(Map<String, dynamic> json) => UserModels(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      photoURL: json['photoURL'] as String?,
    );

Map<String, dynamic> _$UserModelsToJson(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'userId': instance.userId,
      'name': instance.name,
      'country': instance.country,
      'photoURL': instance.photoURL,
    };
