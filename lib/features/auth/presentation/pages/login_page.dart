import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final RegExp _sduEmailRegExp = RegExp(r'^\d+@(stu\.)?sdu\.edu\.kz$');
  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

    if (email.isEmpty || password.isEmpty) {
      _showError('Пожалуйста, заполните все поля');
      return;
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
        if (mounted) context.go('/');
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

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // authenticate() бросает исключение при отмене (не возвращает null)
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final email = googleUser.email;

      if (!_sduEmailRegExp.hasMatch(email)) {
        await GoogleSignIn.instance.signOut();
        _showError('Ошибка: Разрешены только студенческие почты (например: 240103064@sdu.edu.kz)');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // В v7.x authentication — синхронный геттер, и содержит только idToken
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      // Supabase OAuth with Google
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
      );

      _showSuccess('Успешный вход! Добро пожаловать в SDU Match.');
      if (mounted) {
        context.go('/');
      }
    } on GoogleSignInException catch (e) {
      // Пользователь отменил вход
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Ничего не делаем
      } else {
        _showError('Ошибка Google Sign-In: ${e.description ?? e.code}');
      }
    } catch (e) {
      _showError('Произошла ошибка при входе: $e');
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                    letterSpacing: 1.2,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Подзаголовок
                const Text(
                  'Только для студентов SDU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 40),

                // Поле Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: '240103064@sdu.edu.kz',
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

  Widget _buildGoogleButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : _handleGoogleSignIn,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Иконка Google (пока используем Flutter лого как заглушку, позже заменим на SVG)
                const FlutterLogo(size: 24), 
                const SizedBox(width: 16),
                const Text(
                  'Продолжить с Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
