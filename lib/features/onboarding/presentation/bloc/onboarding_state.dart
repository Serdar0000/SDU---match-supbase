import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/onboarding_data.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = OnboardingInitial;
  
  const factory OnboardingState.inProgress({
    required OnboardingData data,
    @Default(0) int currentStep,
  }) = OnboardingInProgress;
  
  const factory OnboardingState.saving() = OnboardingSaving;
  
  const factory OnboardingState.completed() = OnboardingStateCompleted;
  
  const factory OnboardingState.error(String message) = OnboardingError;
}
