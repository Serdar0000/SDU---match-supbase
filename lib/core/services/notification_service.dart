import 'package:supabase_flutter/supabase_flutter.dart';

/// Простой сервис для in-app уведомлений
/// Email отправляются автоматически через Supabase triggers
class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Получить непрочитанные уведомления для текущего пользователя
  Future<List<Map<String, dynamic>>> getUnreadNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('is_read', false)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Отметить уведомление как прочитанное
  Future<void> markAsRead(String notificationId) async {
    await _supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Stream для подсчета непрочитанных уведомлений
  Stream<int> getUnreadCountStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value(0);

    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .map((allNotifications) {
          // Фильтруем только для текущего пользователя и непрочитанные
          return allNotifications.where((n) {
            return n['user_id'] == userId && n['is_read'] == false;
          }).length;
        });
  }
}

