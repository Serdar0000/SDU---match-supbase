import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    required String id,
    required String name,
    required int age,
    required String faculty,
    required int yearOfStudy,
    required String imageUrl,
    required List<String> interests,
    required String bio,
    @Default('') String email,
    @Default('other') String gender, // 'male', 'female', 'other'
    @Default('all') String lookingFor, // 'male', 'female', 'all'
    @Default(0) int starsGiven, // Количество супер-лайков, которые пользователь раздал
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
