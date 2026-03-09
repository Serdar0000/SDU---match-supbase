import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/onboarding_progress_bar.dart';
import 'steps/name_step.dart';
import 'steps/age_step.dart';
import 'steps/gender_step.dart';
import 'steps/looking_for_step.dart';
import 'steps/education_step.dart';
import 'steps/interests_step.dart';
import 'steps/photo_step.dart';

/// Главная страница онбординга с PageView
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalSteps = 7;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleComplete() {
    context.read<OnboardingBloc>().add(
      const OnboardingEvent.completed(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingStateCompleted) {
          context.go('/');
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: OnboardingProgressBar(
            currentStep: _currentPage,
            totalSteps: _totalSteps,
          ),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingSaving) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Создаём твой профиль... ✨',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                NameStep(onNext: _nextPage),
                AgeStep(
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                GenderStep(
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                LookingForStep(
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                EducationStep(
                  onNext: _nextPage,
                  onBack: _previousPage,
                ),
                InterestsStep(
                  onNext: _nextPage,
                  onBack: _previousPage,
                  initialSelected: (state is OnboardingInProgress)
                      ? state.data.interests
                      : const [],
                  onInterestsSelected: (list) {
                    context.read<OnboardingBloc>().add(
                          OnboardingEvent.interestsUpdated(list),
                        );
                  },
                ),
                PhotoStep(
                  onComplete: _handleComplete,
                  onBack: _previousPage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
