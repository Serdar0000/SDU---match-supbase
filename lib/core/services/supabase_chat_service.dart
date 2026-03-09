import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/chat/domain/entities/chat_message.dart';

class SupabaseChatService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== СООБЩЕНИЯ ====================

  /// Stream сообщений для конкретного матча (с Realtime)
  Stream<List<ChatMessage>> getMessages(String matchId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .order('created_at', ascending: true)
        .map((data) {
          return data.map((msg) => ChatMessage(
            id: msg['id'] as String,
            senderId: msg['sender_id'] as String? ?? '',  // NULL для системных сообщений
            text: msg['text'] as String,
            timestamp: DateTime.parse(msg['created_at'] as String),
            isRead: msg['is_read'] as bool? ?? false,
            isSystem: msg['is_system'] as bool? ?? false,  // Новое поле
          )).toList();
        });
  }

  /// Отправить сообщение
  Future<void> sendMessage({
    required String matchId,
    required String text,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null || text.trim().isEmpty) return;

    // Получаем информацию о матче
    final match = await _supabase
        .from('matches')
        .select()
        .eq('id', matchId)
        .single();

    final user1Id = match['user1_id'] as String;

    // Добавляем сообщение
    await _supabase.from('messages').insert({
      'match_id': matchId,
      'sender_id': uid,
      'text': text.trim(),
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Обновляем lastMessage в матче + счётчики
    final Map<String, dynamic> updates = {
      'last_message': text.trim(),
      'last_message_time': DateTime.now().toIso8601String(),
    };

    // Сбрасываем свой счётчик, инкрементируем счётчик получателя
    if (uid == user1Id) {
      updates['unread_count_user1'] = 0;
      updates['unread_count_user2'] = (match['unread_count_user2'] as int? ?? 0) + 1;
    } else {
      updates['unread_count_user2'] = 0;
      updates['unread_count_user1'] = (match['unread_count_user1'] as int? ?? 0) + 1;
    }

    await _supabase
        .from('matches')
        .update(updates)
        .eq('id', matchId);
  }

  /// Отметить все сообщения как прочитанные + сбросить счётчик
  Future<void> markAsRead(String matchId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    // Получаем информацию о матче
    final match = await _supabase
        .from('matches')
        .select()
        .eq('id', matchId)
        .single();

    final user1Id = match['user1_id'] as String;

    // Сбрасываем счётчик непрочитанных
    final updates = uid == user1Id
        ? {'unread_count_user1': 0}
        : {'unread_count_user2': 0};

    await _supabase
        .from('matches')
        .update(updates)
        .eq('id', matchId);

    // Отмечаем непрочитанные сообщения собеседника как прочитанные
    await _supabase
        .from('messages')
        .update({'is_read': true})
        .eq('match_id', matchId)
        .eq('is_read', false)
        .neq('sender_id', uid);
  }

  /// Получить количество непрочитанных сообщений для пользователя
  Future<int> getUnreadCount(String uid) async {
    final matches = await _supabase
        .from('matches')
        .select()
        .or('user1_id.eq.$uid,user2_id.eq.$uid');

    int totalUnread = 0;
    for (final match in matches as List) {
      final user1Id = match['user1_id'] as String;
      final count = uid == user1Id
          ? (match['unread_count_user1'] as int? ?? 0)
          : (match['unread_count_user2'] as int? ?? 0);
      totalUnread += count;
    }

    return totalUnread;
  }

  /// Stream общего количества непрочитанных сообщений
  Stream<int> getUnreadCountStream(String uid) {
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .map((allMatches) {
          // Фильтруем матчи где участвует текущий пользователь
          final matches = allMatches.where((match) {
            final user1Id = match['user1_id'] as String;
            final user2Id = match['user2_id'] as String;
            return user1Id == uid || user2Id == uid;
          });

          int totalUnread = 0;
          for (final match in matches) {
            final user1Id = match['user1_id'] as String;
            final count = uid == user1Id
                ? (match['unread_count_user1'] as int? ?? 0)
                : (match['unread_count_user2'] as int? ?? 0);
            totalUnread += count;
          }
          return totalUnread;
        });
  }

  /// Удалить матч и все связанные сообщения
  Future<void> deleteMatch(String matchId) async {
    // Сначала удаляем сообщения (если ON DELETE CASCADE не работает)
    await _supabase
        .from('messages')
        .delete()
        .eq('match_id', matchId);

    // Затем удаляем сам матч
    await _supabase
        .from('matches')
        .delete()
        .eq('id', matchId);
  }

  /// Получить последнее сообщение для матча
  Future<ChatMessage?> getLastMessage(String matchId) async {
    final response = await _supabase
        .from('messages')
        .select()
        .eq('match_id', matchId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return ChatMessage(
      id: response['id'] as String,
      senderId: response['sender_id'] as String,
      text: response['text'] as String,
      timestamp: DateTime.parse(response['created_at'] as String),
      isRead: response['is_read'] as bool? ?? false,
    );
  }

  /// Stream матчей для текущего пользователя (с Realtime).
  /// Использует два отдельных .eq()-потока (user1 + user2), чтобы
  /// Realtime-подписки корректно доставляли INSERT-события обоим
  /// участникам матча.
  Stream<List<Map<String, dynamic>>> getMatchesStream() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return Stream.value([]);

    // ignore: close_sinks  — lifetime tied to the page's StreamBuilder
    final controller = StreamController<List<Map<String, dynamic>>>();

    List<Map<String, dynamic>> asUser1 = [];
    List<Map<String, dynamic>> asUser2 = [];

    void emit() {
      if (controller.isClosed) return;
      final combined = <String, Map<String, dynamic>>{};
      for (final m in [...asUser1, ...asUser2]) {
        combined[m['id'] as String] = m;
      }
      final list = combined.values.toList()
        ..sort((a, b) {
          final ta = (a['last_message_time'] as String?) ?? '';
          final tb = (b['last_message_time'] as String?) ?? '';
          return tb.compareTo(ta);
        });
      controller.add(list);
    }

    final sub1 = _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('user1_id', uid)
        .listen((data) {
          asUser1 = data;
          emit();
        });

    final sub2 = _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('user2_id', uid)
        .listen((data) {
          asUser2 = data;
          emit();
        });

    controller.onCancel = () {
      sub1.cancel();
      sub2.cancel();
    };

    return controller.stream;
  }
}
