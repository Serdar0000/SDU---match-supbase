import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

/// Шаг 4: Кого ищешь
class LookingForStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LookingForStep({super.key, required this.onNext, required this.onBack});

  @override
  State<LookingForStep> createState() => _LookingForStepState();
}

class _LookingForStepState extends State<LookingForStep> {
  String? _selectedLookingFor;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress) {
      _selectedLookingFor = state.data.lookingFor;
    }
  }

  void _selectLookingFor(String lookingFor) {
    setState(() {
      _selectedLookingFor = lookingFor;
    });
  }

  void _handleNext() {
    if (_selectedLookingFor != null) {
      context.read<OnboardingBloc>().add(
            OnboardingEvent.lookingForSelected(_selectedLookingFor!),
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
            '💘',
            style: TextStyle(fontSize: 64),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Кого ты ищешь?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          _LookingForOption(
            emoji: '👨',
            label: 'Парней',
            value: 'male',
            isSelected: _selectedLookingFor == 'male',
            onTap: () => _selectLookingFor('male'),
          ),
          const SizedBox(height: 16),
          _LookingForOption(
            emoji: '👩',
            label: 'Девушек',
            value: 'female',
            isSelected: _selectedLookingFor == 'female',
            onTap: () => _selectLookingFor('female'),
          ),
          const SizedBox(height: 16),
          _LookingForOption(
            emoji: '💑',
            label: 'Всех',
            value: 'all',
            isSelected: _selectedLookingFor == 'all',
            onTap: () => _selectLookingFor('all'),
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
                  onPressed: _selectedLookingFor != null ? _handleNext : null,
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

class _LookingForOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _LookingForOption({
    required this.emoji,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primaryBlue : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
