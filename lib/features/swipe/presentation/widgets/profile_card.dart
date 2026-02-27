import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../domain/entities/user_profile.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final int swipeProgress; // От -10000 (влево) до 10000 (вправо)

  const ProfileCard({
    super.key,
    required this.profile,
    this.swipeProgress = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: profile.imageUrl.isNotEmpty
                  ? Image.network(
                      CloudinaryService.getOptimizedUrl(
                        profile.imageUrl,
                        width: 600,
                        height: 800,
                      ),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return _buildPlaceholder(
                          showSpinner: true,
                        );
                      },
                    )
                  : _buildPlaceholder(),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Swipe Indicators (Like / Pass)
            if (swipeProgress != 0)
              Positioned.fill(
                child: _buildSwipeIndicator(),
              ),
            // Profile Info
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${profile.faculty}, ${profile.yearOfStudy} курс',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder({bool showSpinner = false}) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: showSpinner
            ? const CircularProgressIndicator(
                color: AppColors.primaryBlue,
                strokeWidth: 3,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 100, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    profile.name,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    // swipeProgress идет от -10000 (влево) до 10000 (вправо)
    final bool isLike = swipeProgress > 0;
    
    // Вместо прозрачности используем увеличение размера (scale), 
    // чтобы цвет всегда оставался на 100% плотным и ярким.
    final double scale = (swipeProgress.abs() / 3000).clamp(0.0, 1.0);

    if (scale == 0.0) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.topCenter, // Прижимаем к верхнему краю
      child: Padding(
        padding: const EdgeInsets.only(top: 50), // Отступ сверху
        child: Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: isLike ? -0.2 : 0.2,
            child: Container(
              padding: const EdgeInsets.all(40), // Оптимальный отступ для гигантской иконки
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isLike ? Colors.green : Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: (isLike ? Colors.green : Colors.red).withOpacity(1.0),
                    blurRadius: 200,
                    spreadRadius: 700,
                  ),
                ],
              ),
              child: Icon(
                isLike ? Icons.favorite : Icons.close,
                color: Colors.white,
                size: 220, // ГИГАНТСКАЯ иконка (было 160)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
