import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sdu_match/core/theme/app_theme.dart';
import 'package:sdu_match/core/services/supabase_service.dart';
import 'package:sdu_match/core/services/cloudinary_service.dart';
import 'package:sdu_match/features/swipe/domain/entities/user_profile.dart';

class EditProfilePage extends StatefulWidget {
  final UserProfile initialProfile;

  const EditProfilePage({super.key, required this.initialProfile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _bioController;
  final _supabaseService = SupabaseService();
  final _cloudinaryService = CloudinaryService();
  final _imagePicker = ImagePicker();

  // Новый файл (если юзер выбрал)
  File? _pickedImage;
  bool _isUploadingImage = false;

  // Текущие значения
  late String _selectedGender;
  late String _selectedLookingFor;
  late String _selectedFaculty;
  late int _selectedYear;
  late List<String> _selectedInterests;

  bool _isLoading = false;

  final List<String> _faculties = [
    'Engineering',
    'Business and Law',
    'Education',
  ];

  final List<String> _allInterests = [
    'AI', 'Flutter', 'Mobile', 'Web', 'Design', 'UI/UX',
    'Стартапы', 'Финансы', 'Крипта', 'Маркетинг',
    'Спорт', 'Зал', 'Бег', 'Йога', 'Танцы',
    'Музыка', 'Кино', 'Аниме', 'Книги', 'Игры',
    'Путешествия', 'Кофе', 'Фотография', 'Искусство',
    'Волонтёрство', 'Дебаты', 'Шахматы', 'Кулинария',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _nameController = TextEditingController(text: p.name);
    _ageController = TextEditingController(text: p.age.toString());
    _bioController = TextEditingController(text: p.bio);
    _selectedGender = p.gender;
    _selectedLookingFor = p.lookingFor;
    _selectedFaculty = _faculties.contains(p.faculty) ? p.faculty : _faculties.first;
    _selectedYear = p.yearOfStudy.clamp(1, 4);
    _selectedInterests = List<String>.from(p.interests);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // -------- Фото --------
  Future<void> _pickImage(ImageSource source) async {
    try {
      final xFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (xFile != null) setState(() => _pickedImage = File(xFile.path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _showPickImageDialog() async {
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
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryBlue),
                title: const Text('Камера'),
                onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
              ),
              if (_pickedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text('Отменить выбор', style: TextStyle(color: AppColors.error)),
                  onTap: () { Navigator.pop(ctx); setState(() => _pickedImage = null); },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // -------- Сохранение --------
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите хотя бы один интерес'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = Supabase.instance.client.auth.currentUser!;

      // Загружаем новое фото, если выбрано
      String imageUrl = widget.initialProfile.imageUrl;
      if (_pickedImage != null) {
        setState(() => _isUploadingImage = true);
        try {
          imageUrl = await _cloudinaryService.uploadImage(
                _pickedImage!,
                folder: 'avatars',
              ) ?? imageUrl;
        } finally {
          if (mounted) setState(() => _isUploadingImage = false);
        }
      }

      final updates = {
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'bio': _bioController.text.trim(),
        'gender': _selectedGender,
        'lookingFor': _selectedLookingFor,
        'faculty': _selectedFaculty,
        'yearOfStudy': _selectedYear,
        'interests': _selectedInterests,
        'imageUrl': imageUrl,
      };

      await _supabaseService.updateUserProfile(user.id, updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Профиль обновлён!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop(true); // возвращаем true → ProfilePage перезагрузит данные
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // -------- UI --------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final existingImageUrl = widget.initialProfile.imageUrl;
    final hasExistingImage = existingImageUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Редактировать профиль',
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Аватарка
                Center(
                  child: GestureDetector(
                    onTap: _showPickImageDialog,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!) as ImageProvider
                              : (hasExistingImage
                                  ? NetworkImage(CloudinaryService.getOptimizedUrl(
                                      existingImageUrl, width: 200, height: 200))
                                  : null),
                          child: (_pickedImage == null && !hasExistingImage)
                              ? const Icon(Icons.person, size: 60, color: AppColors.primaryBlue)
                              : null,
                        ),
                        if (_isUploadingImage)
                          Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.4),
                              child: const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3),
                            ),
                          ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _pickedImage != null
                                  ? AppColors.success
                                  : AppColors.primaryBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              _pickedImage != null ? Icons.check : Icons.camera_alt,
                              color: Colors.white, size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _pickedImage != null ? 'Новое фото выбрано ✓' : 'Нажми чтобы изменить фото',
                    style: TextStyle(
                      color: _pickedImage != null ? AppColors.success : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: _pickedImage != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Имя
                _buildLabel('Имя'),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration(isDark, 'Как тебя зовут?'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                ),

                const SizedBox(height: 20),

                // Возраст
                _buildLabel('Возраст'),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(isDark, '18'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Введите возраст';
                    final age = int.tryParse(v);
                    if (age == null || age < 16 || age > 40) return 'Возраст от 16 до 40';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Пол
                _buildLabel('Пол'),
                _buildSegmentedButton<String>(
                  isDark: isDark,
                  value: _selectedGender,
                  items: const {'male': 'Парень', 'female': 'Девушка' },
                  onChanged: (v) => setState(() => _selectedGender = v),
                ),

                const SizedBox(height: 20),

                // Кого ищешь
                _buildLabel('Кого ищешь?'),
                _buildSegmentedButton<String>(
                  isDark: isDark,
                  value: _selectedLookingFor,
                  items: const {'male': 'Парней', 'female': 'Девушек', 'all': 'Всех'},
                  onChanged: (v) => setState(() => _selectedLookingFor = v),
                ),

                const SizedBox(height: 20),

                // Факультет
                _buildLabel('Факультет'),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFaculty,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(16),
                      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                      items: _faculties.map((f) =>
                        DropdownMenuItem(value: f, child: Text(f))).toList(),
                      onChanged: (v) { if (v != null) setState(() => _selectedFaculty = v); },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Курс
                _buildLabel('Курс'),
                _buildSegmentedButton<int>(
                  isDark: isDark,
                  value: _selectedYear,
                  items: const {1: '1', 2: '2', 3: '3', 4: '4'},
                  onChanged: (v) => setState(() => _selectedYear = v),
                ),

                const SizedBox(height: 20),

                // О себе
                _buildLabel('О себе'),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: _inputDecoration(isDark, 'Расскажи немного о себе...'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Напиши о себе' : null,
                ),

                const SizedBox(height: 20),

                // Интересы
                _buildLabel('Интересы (выбери 3+)'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                      selectedColor: AppColors.primaryBlue.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Кнопка сохранения
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
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
                          height: 24, width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Сохранить',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark, String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildSegmentedButton<T>({
    required bool isDark,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    return Row(
      children: items.entries.map((entry) {
        final isSelected = value == entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onChanged(entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : (isDark ? AppColors.darkCard : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
