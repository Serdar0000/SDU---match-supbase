import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

/// Шаг 5: Факультет + Курс
class EducationStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const EducationStep({super.key, required this.onNext, required this.onBack});

  @override
  State<EducationStep> createState() => _EducationStepState();
}

class _EducationStepState extends State<EducationStep> {
  String? _selectedFaculty;
  int? _selectedYear;

  static const List<String> _faculties = [
    'Engineering',
    'Business School',
    'Law',
    'Education',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress) {
      _selectedFaculty = state.data.faculty;
      _selectedYear = state.data.yearOfStudy;
    }
  }

  void _selectYear(int year) {
    setState(() {
      _selectedYear = year;
    });
  }

  bool _isValid() => _selectedFaculty != null && _selectedYear != null;

  void _handleNext() {
    if (_isValid()) {
      context.read<OnboardingBloc>().add(
            OnboardingEvent.facultySelected(_selectedFaculty!),
          );
      context.read<OnboardingBloc>().add(
            OnboardingEvent.yearOfStudySelected(_selectedYear!),
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
            '🎓',
            style: TextStyle(fontSize: 64),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Расскажи об учёбе',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          const Text(
            'Факультет',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedFaculty != null
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFaculty,
                hint: const Text('Выбери факультет'),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: _faculties.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Text(faculty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Курс',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [1, 2, 3, 4].map((year) {
              final isSelected = _selectedYear == year;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => _selectYear(year),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$year',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
