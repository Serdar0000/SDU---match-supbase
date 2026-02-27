import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import 'package:sdu_match/core/di/injection.dart' as di;
import 'package:sdu_match/core/services/mock_data_service.dart';
import 'package:sdu_match/features/swipe/domain/entities/user_profile.dart';
import 'package:sdu_match/l10n/generated/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SupabaseService _supabaseService = SupabaseService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  late final MockDataService? _mockService;
  final ImagePicker _imagePicker = ImagePicker();
  UserProfile? _myProfile;
  bool _isLoading = true;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    if (AppConfig.DEV_MODE) {
      _mockService = di.sl<MockDataService>();
    } else {
      _mockService = null;
    }
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // 🚧 DEV MODE: Используем моковые данные
    if (AppConfig.DEV_MODE && _mockService != null) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _myProfile = _mockService.currentUserProfile;
          _isLoading = false;
        });
      }
      return;
    }
    
    final profile = await _supabaseService.getCurrentUserProfile();
    if (mounted) {
      setState(() {
        _myProfile = profile;
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    // 🚧 DEV MODE: Просто показываем сообщение
    if (AppConfig.DEV_MODE) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚧 Dev режим - выход отключен'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await Supabase.instance.client.auth.signOut();
    if (mounted) context.go('/login');
  }

  Future<void> _changePhoto(ImageSource source) async {
    // 🎭 MOCK VERSION - просто показываем уведомление
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎭 Mock режим - загрузка фото отключена'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    /* ОРИГИНАЛЬНЫЙ КОД SUPABASE
    try {
      final xFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (xFile == null || !mounted) return;

      setState(() => _isUploadingPhoto = true);
      final url = await _cloudinaryService.uploadImage(
        File(xFile.path),
        folder: 'avatars',
      );
      if (url != null && mounted) {
        final user = Supabase.instance.client.auth.currentUser!;
        await _supabaseService.updateUserProfile(user.id, {'imageUrl': url});
        setState(() {
          _myProfile = _myProfile!.copyWith(imageUrl: url);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фото обновлено!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingPhoto = false);
    }
    */
  }

  Future<void> _showPhotoDialog() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text('Изменить фото',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primaryBlue),
                title: const Text('Галерея'),
                onTap: () { Navigator.pop(ctx); _changePhoto(ImageSource.gallery); },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryBlue),
                title: const Text('Камера'),
                onTap: () { Navigator.pop(ctx); _changePhoto(ImageSource.camera); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_myProfile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Профиль не найден'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Выйти'),
              ),
            ],
          ),
        ),
      );
    }

    final myProfile = _myProfile!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context)?.profile ?? 'Профиль',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.primary),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Аватарка
            GestureDetector(
              onTap: _showPhotoDialog,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryBlue, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: myProfile.imageUrl.isNotEmpty
                          ? NetworkImage(CloudinaryService.getOptimizedUrl(
                              myProfile.imageUrl,
                              width: 200,
                              height: 200,
                            ))
                          : null,
                      child: myProfile.imageUrl.isEmpty
                          ? const Icon(Icons.person, size: 60, color: AppColors.primaryBlue)
                          : null,
                    ),
                  ),
                  // Загрузка или кнопка редактирования
                  if (_isUploadingPhoto)
                    Positioned.fill(
                      child: CircleAvatar(
                        backgroundColor: Colors.black38,
                        child: const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 3),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Имя и возраст
            Text(
              '${myProfile.name}, ${myProfile.age}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            
            // Звездочки (супер-лайки)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '${myProfile.starsGiven} супер-лайков раздано',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Факультет и курс
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${myProfile.faculty} • ${myProfile.yearOfStudy} курс',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // О себе
            _buildSectionTitle(S.of(context)?.aboutMe ?? 'О себе'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                myProfile.bio,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Интересы
            _buildSectionTitle(S.of(context)?.myInterests ?? 'Мои интересы'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: myProfile.interests.map((interest) {
                  return Chip(
                    label: Text(interest),
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
            
            // Кнопки
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/profile/edit',
                    extra: myProfile,
                  );
                  if (updated == true) _loadProfile();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  S.of(context)?.editProfile ?? 'Редактировать профиль',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _signOut,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  S.of(context)?.signOut ?? 'Выйти',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 100), // Отступ для плавающего NavigationBar
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
