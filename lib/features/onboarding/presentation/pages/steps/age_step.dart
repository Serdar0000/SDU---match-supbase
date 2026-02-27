import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

/// Шаг 2: Выбор возраста
class AgeStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AgeStep({super.key, required this.onNext, required this.onBack});

  @override
  State<AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<AgeStep> {
  int _selectedAge = 20;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress) {
      _selectedAge = state.data.age;
    }
  }

  bool _isValid() => _selectedAge >= 17 && _selectedAge <= 100;

  void _handleNext() {
    if (_isValid()) {
      context.read<OnboardingBloc>().add(
            OnboardingEvent.ageUpdated(_selectedAge),
          );
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🎂',
            style: TextStyle(fontSize: 64),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Сколько тебе лет?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '$_selectedAge',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _selectedAge > 17
                          ? () => setState(() => _selectedAge--)
                          : null,
                      icon: const Icon(Icons.remove_circle_outline, size: 40),
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: _selectedAge < 100
                          ? () => setState(() => _selectedAge++)
                          : null,
                      icon: const Icon(Icons.add_circle_outline, size: 40),
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Возраст: 17-100 лет',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Назад',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _isValid() ? _handleNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Следующий',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
