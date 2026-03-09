import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../chat/domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool showTime;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // System message: center alignment, neutral style
    if (message.isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.grey.shade800 
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: isDark 
                    ? Colors.grey.shade300 
                    : Colors.grey.shade700,
                fontSize: 13,
                height: 1.3,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    // Regular user message
    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 60 : 12,
        right: isMe ? 12 : 60,
        top: 2,
        bottom: showTime ? 0 : 2,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.primaryBlue
                  : (isDark ? AppColors.darkCard : Colors.grey.shade200),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Время + галочки
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: TextStyle(
                        color: isMe
                            ? Colors.white.withValues(alpha: 0.7)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                        fontSize: 11,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: message.isRead
                            ? Colors.lightBlueAccent
                            : Colors.white.withValues(alpha: 0.7),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Разделитель даты между сообщениями
class DateDivider extends StatelessWidget {
  final DateTime date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(msgDay).inDays;

    String label;
    if (diff == 0) {
      label = 'Сегодня';
    } else if (diff == 1) {
      label = 'Вчера';
    } else {
      label = DateFormat('d MMMM', 'ru').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
