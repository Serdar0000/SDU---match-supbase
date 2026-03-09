import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_event.freezed.dart';

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.started() = OnboardingStarted;
  const factory OnboardingEvent.nameUpdated(String name) = OnboardingNameUpdated;
  const factory OnboardingEvent.ageUpdated(int age) = OnboardingAgeUpdated;
  const factory OnboardingEvent.genderSelected(String gender) = OnboardingGenderSelected;
  const factory OnboardingEvent.lookingForSelected(String lookingFor) = OnboardingLookingForSelected;
  const factory OnboardingEvent.facultySelected(String faculty) = OnboardingFacultySelected;
  const factory OnboardingEvent.yearOfStudySelected(int year) = OnboardingYearOfStudySelected;
  const factory OnboardingEvent.photoUploadStarted() = OnboardingPhotoUploadStarted;
  const factory OnboardingEvent.photoUploaded(String url) = OnboardingPhotoUploaded;
  const factory OnboardingEvent.photoUploadFailed(String error) = OnboardingPhotoUploadFailed;
  const factory OnboardingEvent.interestsUpdated(List<String> interests) = OnboardingInterestsUpdated;
  const factory OnboardingEvent.completed() = OnboardingCompleted;
}
