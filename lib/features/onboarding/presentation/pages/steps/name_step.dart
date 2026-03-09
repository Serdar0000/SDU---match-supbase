import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

/// Шаг 1: Ввод имени
class NameStep extends StatefulWidget {
  final VoidCallback onNext;

  const NameStep({super.key, required this.onNext});

  @override
  State<NameStep> createState() => _NameStepState();
}

class _NameStepState extends State<NameStep> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Загружаем сохранённое имя один раз
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress && state.data.name.isNotEmpty) {
      _controller.text = state.data.name;
    }
    
    // Автофокус на текстовое поле
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _isValid() => _controller.text.trim().length >= 2;

  void _handleNext() {
    if (_isValid()) {
      // Убираем клавиатуру перед переходом
      FocusScope.of(context).unfocus();
      context.read<OnboardingBloc>().add(
        OnboardingEvent.nameUpdated(_controller.text.trim()),
      );
      // Добавляем небольшую задержку, чтобы клавиатура успела скрыться
      Future.delayed(const Duration(milliseconds: 250), () {
        widget.onNext();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '👋',
              style: TextStyle(fontSize: 64),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Добро пожаловать\nв SDU Match!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const Text(
              'Как тебя зовут?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Введи своё имя...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primaryBlue,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
              ),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _handleNext(),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
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
                    'Продолжить',
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
          ],
        ),
      ),
    );
  }
}
