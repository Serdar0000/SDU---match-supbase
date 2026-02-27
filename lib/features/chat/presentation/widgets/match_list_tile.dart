import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../swipe/domain/entities/user_profile.dart';

class MatchListTile extends StatelessWidget {
  final UserProfile profile;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final VoidCallback onTap;

  const MatchListTile({
    super.key,
    required this.profile,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarUrl = profile.imageUrl.isNotEmpty
        ? CloudinaryService.getOptimizedUrl(profile.imageUrl,
            width: 120, height: 120)
        : '';
    final timeStr = _formatTime(lastMessageTime);
    final hasUnread = unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Аватар
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
                  child: avatarUrl.isEmpty
                      ? Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                // Онлайн-индикатор (можно добавить позже)
              ],
            ),

            const SizedBox(width: 12),

            // Имя + последнее сообщение
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontWeight:
                          hasUnread ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage.isEmpty ? 'Нет сообщений' : lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: hasUnread
                          ? (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary)
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                      fontWeight: hasUnread
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Время + значок непрочитанных
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (timeStr.isNotEmpty)
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasUnread
                          ? AppColors.primaryBlue
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 4),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    if (now.difference(dt).inDays == 0) {
      return DateFormat('HH:mm').format(dt);
    } else if (now.difference(dt).inDays == 1) {
      return 'Вчера';
    } else if (now.difference(dt).inDays < 7) {
      return DateFormat('EEEE', 'ru').format(dt);
    } else {
      return DateFormat('dd.MM').format(dt);
    }
  }
}

/// Карточка нового матча (горизонтальный список без сообщений)
class NewMatchChip extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onTap;

  const NewMatchChip({super.key, required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.imageUrl.isNotEmpty
        ? CloudinaryService.getOptimizedUrl(profile.imageUrl,
            width: 120, height: 120)
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundImage:
                    avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                backgroundColor: Colors.grey.shade300,
                child: avatarUrl.isEmpty
                    ? Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 70,
              child: Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
