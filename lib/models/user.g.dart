// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModels _$UserModelsFromJson(Map<String, dynamic> json) => UserModels(
      id: json['id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      recipes: json['recipes'] as List<dynamic>?,
      favorite: json['favorite'] as List<dynamic>?,
      image: json['image'] as String?,
    );

UserModels _$UserModelsFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data();
  return UserModels(
    id: doc.id,
    email: data?['email'] as String?,
    name: data?['name'] as String?,
    recipes: data?['recipes'] as List<dynamic>?,
    favorite: data?['favorite'] as List<dynamic>?,
    image: data?['image'] as String?,
  );
}

Map<String, dynamic> _$UserModelsToJson(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'name': instance.name,
      'recipes': instance.recipes,
      'favorite': instance.favorite,
      'image': instance.image,
    };

Map<String, dynamic> _$UserModelsToFirebase(UserModels instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'recipes': instance.recipes,
      'favorite': instance.favorite,
      'image': instance.image,
    };
