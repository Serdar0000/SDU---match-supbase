import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../swipe/domain/entities/user_profile.dart';
import '../../domain/entities/onboarding_data.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SupabaseService _supabaseService;

  OnboardingBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? SupabaseService(),
        super(const OnboardingState.initial()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingNameUpdated>(_onNameUpdated);
    on<OnboardingAgeUpdated>(_onAgeUpdated);
    on<OnboardingGenderSelected>(_onGenderSelected);
    on<OnboardingLookingForSelected>(_onLookingForSelected);
    on<OnboardingFacultySelected>(_onFacultySelected);
    on<OnboardingYearOfStudySelected>(_onYearOfStudySelected);
    on<OnboardingPhotoUploadStarted>(_onPhotoUploadStarted);
    on<OnboardingPhotoUploaded>(_onPhotoUploaded);
    on<OnboardingPhotoUploadFailed>(_onPhotoUploadFailed);
    on<OnboardingInterestsUpdated>(_onInterestsUpdated);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onStarted(OnboardingStarted event, Emitter<OnboardingState> emit) {
    emit(const OnboardingState.inProgress(
      data: OnboardingData(),
      currentStep: 0,
    ));
  }

  void _onNameUpdated(OnboardingNameUpdated event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(name: event.name),
      ));
    }
  }

  void _onAgeUpdated(OnboardingAgeUpdated event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(age: event.age),
      ));
    }
  }

  void _onGenderSelected(OnboardingGenderSelected event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(gender: event.gender),
      ));
    }
  }

  void _onLookingForSelected(OnboardingLookingForSelected event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(lookingFor: event.lookingFor),
      ));
    }
  }

  void _onFacultySelected(OnboardingFacultySelected event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(faculty: event.faculty),
      ));
    }
  }

  void _onYearOfStudySelected(OnboardingYearOfStudySelected event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(yearOfStudy: event.year),
      ));
    }
  }

  void _onPhotoUploadStarted(OnboardingPhotoUploadStarted event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(isPhotoUploading: true),
      ));
    }
  }

  void _onPhotoUploaded(OnboardingPhotoUploaded event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(
          photoUrl: event.url,
          isPhotoUploading: false,
        ),
      ));
    }
  }

  void _onPhotoUploadFailed(OnboardingPhotoUploadFailed event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(isPhotoUploading: false),
      ));
      emit(OnboardingState.error(event.error));
      // Вернуться обратно в inProgress
      emit(current);
    }
  }

  void _onInterestsUpdated(OnboardingInterestsUpdated event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final current = state as OnboardingInProgress;
      emit(current.copyWith(
        data: current.data.copyWith(interests: event.interests),
      ));
    }
  }

  Future<void> _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    if (state is! OnboardingInProgress) return;
    
    final current = state as OnboardingInProgress;
    final data = current.data;

    if (!data.isComplete) {
      emit(const OnboardingState.error('Пожалуйста, заполните все поля'));
      emit(current);
      return;
    }

    emit(const OnboardingState.saving());

    try {
      // 🚧 DEV MODE: Пропускаем сохранение в Supabase
      if (AppConfig.DEV_MODE) {
        await Future.delayed(const Duration(milliseconds: 500)); // Имитация загрузки
        emit(const OnboardingState.completed());
        return;
      }
      
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Пользователь не авторизован');
      }

      // Создаём профиль пользователя
      final profile = UserProfile(
        id: user.id,
        email: user.email ?? '',
        name: data.name,
        age: data.age,
        gender: data.gender!,
        lookingFor: data.lookingFor!,
        faculty: data.faculty!,
        yearOfStudy: data.yearOfStudy!,
        imageUrl: data.photoUrl!,
        interests: data.interests,
        bio: '',
      );

      await _supabaseService.saveUserProfile(profile);
      
      emit(const OnboardingState.completed());
    } catch (e) {
      emit(OnboardingState.error('Ошибка сохранения: $e'));
      emit(current);
    }
  }
}
