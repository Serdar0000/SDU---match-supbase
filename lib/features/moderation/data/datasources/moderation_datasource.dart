import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModerationDataSource {
  final SupabaseClient _supabase;

  ModerationDataSource({required SupabaseClient supabase})
      : _supabase = supabase;

  /// Получить текущего пользователя
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Создать жалобу
  Future<void> createReport({
    required String reportedId,
    required String reason,
    String? details,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    await _supabase.from('reports').insert({
      'reporter_id': uid,
      'reported_id': reportedId,
      'reason': reason,
      'details': details,
    });
  }

  /// Создать блокировку
  Future<void> createBlock({required String blockedId}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    // Вставляем блокировку
    await _supabase.from('blocks').insert({
      'blocker_id': uid,
      'blocked_id': blockedId,
    });

    // Находим матч и удаляем его (каскадное удаление сообщений)
    final matches = await _supabase
        .from('matches')
        .select('id')
        .or('(user1_id.eq.$uid,user2_id.eq.$blockedId),(user1_id.eq.$blockedId,user2_id.eq.$uid)')
        .limit(1);

    if (matches.isNotEmpty) {
      final matchId = matches[0]['id'];
      await _supabase.from('matches').delete().eq('id', matchId);
    }
  }

  /// Удалить блокировку
  Future<void> deleteBlock({required String blockedId}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    await _supabase
        .from('blocks')
        .delete()
        .eq('blocker_id', uid)
        .eq('blocked_id', blockedId);
  }

  /// Получить список заблокированных ID
  Future<List<String>> getBlockedIds() async {
    final uid = currentUserId;
    if (uid == null) return [];

    // Получаем пользователей, заблокированных текущим юзером
    final blocked = await _supabase
        .from('blocks')
        .select('blocked_id')
        .eq('blocker_id', uid);

    // Получаем пользователей, которые заблокировали текущего юзера
    final blockedBy = await _supabase
        .from('blocks')
        .select('blocker_id')
        .eq('blocked_id', uid);

    final blockedIds = blocked.map<String>((e) => e['blocked_id'] as String).toList();
    final blockedByIds = blockedBy.map<String>((e) => e['blocker_id'] as String).toList();

    return {...blockedIds, ...blockedByIds}.toList();
  }

  /// Поток заблокированных ID (обновляется в реальном времени)
  Stream<List<String>> watchBlockedIds() {
    final uid = currentUserId;
    if (uid == null) return Stream.empty();

    return _supabase
        .from('blocks')
        .stream(primaryKey: ['id'])
        .map((blocks) {
      final blockedIds = blocks
          .where((b) => b['blocker_id'] == uid)
          .map<String>((e) => e['blocked_id'] as String)
          .toList();

      final blockedByIds = blocks
          .where((b) => b['blocked_id'] == uid)
          .map<String>((e) => e['blocker_id'] as String)
          .toList();

      return {...blockedIds, ...blockedByIds}.toList();
    });
  }

  /// Удалить аккаунт (GDPR) - используем встроенную Supabase функцию
  /// которая удаляет профиль (auth.users удаляется автоматически через CASCADE)
  Future<void> deleteUserAccount(String userId) async {
    try {
      // Вызываем SQL функцию которая удалит профиль и все связанные данные
      // Суpabase CASCADE автоматически удалит записи из auth.users
      final response = await _supabase.rpc(
        'delete_user_account',
        params: {'user_id': userId},
      );

      final data = response as Map<String, dynamic>?;
      if (data == null || data['success'] != true) {
        throw Exception(data?['error'] ?? 'Failed to delete account');
      }
      
      debugPrint('✅ Account deleted: ${data['message']}');
    } catch (e) {
      debugPrint('❌ Failed to delete account: $e');
      throw Exception('Failed to delete account: $e');
    }
  }
}
