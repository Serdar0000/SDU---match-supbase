// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  faculty: json['faculty'] as String,
  yearOfStudy: (json['yearOfStudy'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  interests: (json['interests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  bio: json['bio'] as String,
  email: json['email'] as String? ?? '',
  gender: json['gender'] as String? ?? 'other',
  lookingFor: json['lookingFor'] as String? ?? 'all',
  starsGiven: (json['starsGiven'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'faculty': instance.faculty,
      'yearOfStudy': instance.yearOfStudy,
      'imageUrl': instance.imageUrl,
      'interests': instance.interests,
      'bio': instance.bio,
      'email': instance.email,
      'gender': instance.gender,
      'lookingFor': instance.lookingFor,
      'starsGiven': instance.starsGiven,
    };
