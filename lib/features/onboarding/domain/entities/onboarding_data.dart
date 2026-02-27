import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_data.freezed.dart';

/// Модель данных для онбординга нового пользователя
@freezed
abstract class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    @Default('') String name,
    @Default(20) int age,
    String? gender,
    String? lookingFor,
    String? faculty,
    int? yearOfStudy,
    String? photoUrl,
    @Default(false) bool isPhotoUploading,
  }) = _OnboardingData;

  /// Проверка завершенности онбординга
  bool get isComplete =>
      name.isNotEmpty &&
      age >= 17 &&
      age <= 100 &&
      gender != null &&
      lookingFor != null &&
      faculty != null &&
      yearOfStudy != null &&
      photoUrl != null;

  /// Прогресс онбординга (0.0 - 1.0)
  double get progress {
    int completed = 0;
    if (name.isNotEmpty) completed++;
    if (age >= 17 && age <= 100) completed++;
    if (gender != null) completed++;
    if (lookingFor != null) completed++;
    if (faculty != null && yearOfStudy != null) completed++;
    if (photoUrl != null) completed++;
    return completed / 6.0;
  }
}
