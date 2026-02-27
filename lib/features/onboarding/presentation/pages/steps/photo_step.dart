import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/cloudinary_service.dart';
import '../../bloc/onboarding_bloc.dart';
import '../../bloc/onboarding_event.dart';
import '../../bloc/onboarding_state.dart';

/// Шаг 6: Загрузка фото (обязательно!)
class PhotoStep extends StatefulWidget {
  final VoidCallback onComplete;
  final VoidCallback onBack;

  const PhotoStep({super.key, required this.onComplete, required this.onBack});

  @override
  State<PhotoStep> createState() => _PhotoStepState();
}

class _PhotoStepState extends State<PhotoStep> {
  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  String? _photoUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<OnboardingBloc>().state;
    if (state is OnboardingInProgress) {
      _photoUrl = state.data.photoUrl;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final xFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (xFile == null || !mounted) return;

      setState(() => _isUploading = true);
      context.read<OnboardingBloc>().add(
            const OnboardingEvent.photoUploadStarted(),
          );

      final url = await _cloudinaryService.uploadImage(
        File(xFile.path),
        folder: 'avatars',
      );

      if (url != null && mounted) {
        setState(() {
          _photoUrl = url;
          _isUploading = false;
        });
        context.read<OnboardingBloc>().add(
              OnboardingEvent.photoUploaded(url),
            );
        
        // Показываем успех
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Фото загружено! ✓'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Не удалось загрузить фото');
      }
    } catch (e) {
      debugPrint('Ошибка загрузки фото: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        context.read<OnboardingBloc>().add(
              OnboardingEvent.photoUploadFailed(e.toString()),
            );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showPhotoSourceDialog() async {
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
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Выбери источник',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primaryBlue),
                title: const Text('Галерея'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primaryBlue),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
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
            '📸',
            style: TextStyle(fontSize: 64),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Добавь своё фото',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: _isUploading ? null : _showPhotoSourceDialog,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _photoUrl != null
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: _isUploading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Загрузка...',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            children: [
                              Image.network(
                                CloudinaryService.getOptimizedUrl(
                                  _photoUrl!,
                                  width: 400,
                                  height: 400,
                                ),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Icon(
                              Icons.add_circle_outline,
                              size: 40,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Нажми чтобы выбрать',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: AppColors.error,
              ),
              const SizedBox(width: 8),
              Text(
                'Фото обязательно!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _photoUrl == null ? AppColors.error : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: _isUploading ? null : widget.onBack,
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
                  onPressed: _photoUrl != null && !_isUploading
                      ? widget.onComplete
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
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
                        'Завершить',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check, size: 20),
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
