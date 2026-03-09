import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sdu_match/core/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isLoginMode = true; // true = Login, false = Register
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final RegExp _sduEmailRegExp = RegExp(r'^\d+@(stu\.)?sdu\.edu\.kz$');
  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _handleEmailPasswordSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Пожалуйста, заполните все поля');
      return;
    }

    // Проверка совпадения паролей при регистрации
    if (!_isLoginMode) {
      if (confirmPassword.isEmpty) {
        _showError('Пожалуйста, повторите пароль');
        return;
      }
      if (password != confirmPassword) {
        _showError('Пароли не совпадают');
        return;
      }
    }

    if (!_sduEmailRegExp.hasMatch(email)) {
      _showError('Разрешены только студенческие почты (например: 240103064@sdu.edu.kz)');
      return;
    }

    if (password.length < 6) {
      _showError('Пароль должен содержать минимум 6 символов');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLoginMode) {
        // Вход
        await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        _showSuccess('Успешный вход!');
        if (mounted) context.go('/');
      } else {
        // Регистрация
        await _supabase.auth.signUp(
          email: email,
          password: password,
        );
        _showSuccess('Регистрация успешна! Проверьте почту для подтверждения.');
        
        // Очистить все поля
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        
        // Переключиться на режим входа
        if (mounted) {
          setState(() {
            _isLoginMode = true;
          });
        }
      }
    } on AuthException catch (e) {
      String errorMessage = 'Произошла ошибка';
      if (e.message.contains('Invalid login credentials')) {
        errorMessage = 'Неверный email или пароль';
      } else if (e.message.contains('User already registered')) {
        errorMessage = 'Эта почта уже зарегистрирована';
      } else {
        errorMessage = e.message;
      }
      _showError(errorMessage);
    } catch (e) {
      _showError('Ошибка: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Логотип
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 50,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Заголовок
                Text(
                  _isLoginMode ? 'С возвращением!' : 'Создать аккаунт',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                // Поле Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email (@sdu.edu.kz)',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 16),

                // Поле Пароль
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Пароль',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                // Поле "Повторите пароль" (только при регистрации)
                if (!_isLoginMode) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Повторите пароль',
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Кнопка Войти / Зарегистрироваться
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailPasswordSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          _isLoginMode ? 'Войти' : 'Зарегистрироваться',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                // Переключатель режима
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                      // Очистить поле повторного пароля при переключении режима
                      _confirmPasswordController.clear();
                    });
                  },
                  child: Text(
                    _isLoginMode
                        ? 'Нет аккаунта? Зарегистрироваться'
                        : 'Уже есть аккаунт? Войти',
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
