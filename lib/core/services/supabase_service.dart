import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/swipe/domain/entities/user_profile.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ==================== ПРОФИЛИ ====================

  /// Создать или обновить профиль пользователя
  Future<void> saveUserProfile(UserProfile profile) async {
    final data = {
      'id': profile.id,
      'email': profile.email,
      'name': profile.name,
      'age': profile.age,
      'gender': profile.gender,
      'major': profile.faculty, // faculty -> major
      'interests': profile.interests,
      'photos': [profile.imageUrl], // Одно фото в массив
      'bio': profile.bio,
      'stars_given': profile.starsGiven, // Супер-лайки (по умолчанию 0)
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from('profiles').upsert(data);
  }

  /// Получить профиль по uid
  Future<UserProfile?> getUserProfile(String uid) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    if (response == null) return null;

    return UserProfile(
      id: response['id'] as String,
      name: response['name'] ?? '',
      age: response['age'] ?? 18,
      faculty: response['major'] ?? '',
      yearOfStudy: 1, // TODO: добавить в таблицу если нужно
      imageUrl: (response['photos'] as List?)?.isNotEmpty == true
          ? (response['photos'] as List).first
          : '',
      interests: List<String>.from(response['interests'] ?? []),
      bio: response['bio'] ?? '',
      email: response['email'] ?? '',
      gender: response['gender'] ?? 'other',
      lookingFor: 'all', // TODO: добавить в таблицу если нужно
      starsGiven: response['stars_given'] ?? 0,
    );
  }

  /// Получить текущий профиль
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.id);
  }

  /// Проверить, существует ли профиль (для онбординга)
  Future<bool> hasProfile(String uid) async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', uid)
        .maybeSingle();
    return response != null;
  }

  /// Обновить отдельные поля профиля
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    // Если явно передали null для stars_given — установим 0 по умолчанию
    if (data.containsKey('stars_given') && data['stars_given'] == null) {
      data['stars_given'] = 0;
    }
    await _supabase.from('profiles').update(data).eq('id', uid);
  }

  /// Сохранить / обновить FCM-токен текущего пользователя
  Future<void> saveFcmToken(String token) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    await _supabase
        .from('profiles')
        .update({'fcm_token': token}).eq('id', uid);
  }

  // ==================== REPORTS & BLOCKS ====================

  /// Подать жалобу на пользователя
  Future<void> reportUser({
    required String reportedId,
    required String reason,
    String? details,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase.from('reports').insert({
      'reporter_id': uid,
      'reported_id': reportedId,
      'reason': reason,
      'details': details,
    });
  }

  /// Заблокировать пользователя
  Future<void> blockUser(String blockedId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    await _supabase.from('blocks').insert({
      'blocker_id': uid,
      'blocked_id': blockedId,
    });
  }

  /// Проверить, заблокирован ли пользователь текущим
  Future<bool> isBlocked(String otherId) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return false;

    final response = await _supabase
        .from('blocks')
        .select('id')
        .eq('blocker_id', uid)
        .eq('blocked_id', otherId)
        .maybeSingle();

    return response != null;
  }

  /// Получить список ID заблокированных пользователей (в обе стороны)
  Future<List<String>> getBlockedUserIds() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return [];

    // Кто заблокирован мною
    final blockedByMe = await _supabase
        .from('blocks')
        .select('blocked_id')
        .eq('blocker_id', uid);

    // Кто заблокировал меня
    final blockingMe = await _supabase
        .from('blocks')
        .select('blocker_id')
        .eq('blocked_id', uid);

    final ids = <String>{};
    for (final row in blockedByMe) {
      ids.add(row['blocked_id'] as String);
    }
    for (final row in blockingMe) {
      ids.add(row['blocker_id'] as String);
    }

    return ids.toList();
  }

  /// Получить профили для свайпа (исключая себя, просвайпанных и заблокированных)
  Future<List<UserProfile>> getProfilesToSwipe({
    required String currentUid,
    required List<String> swipedIds,
    String? genderFilter,
  }) async {
    // 1. Получаем список заблокированных
    final blockedIds = await getBlockedUserIds();
    
    // 2. Объединяем с уже просвайпанными
    final excludeIds = {currentUid, ...swipedIds, ...blockedIds}.toList();

    // 3. Базовый запрос
    var query = _supabase.from('profiles').select();
    
    // 4. Фильтруем (not in list)
    if (excludeIds.isNotEmpty) {
      query = query.not('id', 'in', '(${excludeIds.join(",")})');
    }
    
    if (genderFilter != null && genderFilter != 'all') {
      query = query.eq('gender', genderFilter);
    }

    final response = await query.limit(20);
    
    return (response as List).map((data) => UserProfile(
      id: data['id'] as String,
      name: data['name'] ?? '',
      age: data['age'] ?? 18,
      faculty: data['major'] ?? '',
      yearOfStudy: 1,
      imageUrl: (data['photos'] as List?)?.isNotEmpty == true
          ? (data['photos'] as List).first
          : '',
      interests: List<String>.from(data['interests'] ?? []),
      bio: data['bio'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? 'other',
      lookingFor: 'all',
      starsGiven: data['stars_given'] ?? 0,
    )).toList();
  }

  /// Получить список профилей с фильтрацией по полу и исключением свайпнутых
  Future<List<UserProfile>> getProfiles({
    String? genderFilter,
    required List<String> swipedIds,
  }) async {
    var query = _supabase.from('profiles').select();
    if (genderFilter != null && genderFilter != 'all') {
      query = query.eq('gender', genderFilter);
    }
    final response = await query.limit(50);
    final profiles = (response as List)
        .where((data) => !swipedIds.contains(data['id']))
        .map((data) => UserProfile(
              id: data['id'] as String,
              name: data['name'] ?? '',
              age: data['age'] ?? 18,
              faculty: data['major'] ?? '',
              yearOfStudy: 1,
              imageUrl: (data['photos'] as List?)?.isNotEmpty == true
                  ? (data['photos'] as List).first
                  : '',
              interests: List<String>.from(data['interests'] ?? []),
              bio: data['bio'] ?? '',
              email: data['email'] ?? '',
              gender: data['gender'] ?? 'other',
              lookingFor: 'all',
            ))
        .toList();
    return profiles;
  }

  // ==================== СВАЙПЫ ====================

  /// Сохранить свайп. Возвращает matchId если это взаимный лайк, иначе null.
  /// Использует SECURITY DEFINER RPC чтобы обойти RLS при проверке обратного лайка.
  Future<String?> saveSwipe({
    required String fromUid,
    required String toUid,
    required String action, // 'like', 'superlike' или 'pass'
  }) async {
    // Нормализуем 'superlike' в 'like' для сохранения в БД
    final dbAction = action == 'superlike' ? 'like' : action;

    final result = await _supabase.rpc(
      'save_swipe_and_check_match',
      params: {
        'p_from_uid': fromUid,
        'p_to_uid': toUid,
        'p_action': dbAction,
      },
    );

    return result as String?;
  }

  /// Получить список ID профилей, которые мы уже свайпнули
  Future<List<String>> getSwipedProfileIds(String uid) async {
    final response = await _supabase
        .from('swipes')
        .select('to_user_id')
        .eq('from_user_id', uid);

    return (response as List).map((e) => e['to_user_id'] as String).toList();
  }

  // ==================== МАТЧИ ====================

  /// Получить матчи текущего пользователя
  Future<List<Map<String, dynamic>>> getMatches(String uid) async {
    // Получаем матчи где пользователь user1 или user2
    final response = await _supabase
        .from('matches')
        .select()
        .or('user1_id.eq.$uid,user2_id.eq.$uid')
        .order('last_message_time', ascending: false);

    final matches = <Map<String, dynamic>>[];
    for (final data in response as List) {
      final user1Id = data['user1_id'] as String;
      final user2Id = data['user2_id'] as String;
      final otherUid = user1Id == uid ? user2Id : user1Id;

      // Получаем профиль другого пользователя
      final otherProfile = await getUserProfile(otherUid);
      if (otherProfile != null) {
        matches.add({
          'matchId': data['id'],
          'profile': otherProfile,
          'lastMessage': data['last_message'] ?? '',
          'timestamp': DateTime.parse(data['last_message_time'] as String),
        });
      }
    }

    return matches;
  }

  /// Проверяем, есть ли матч между двумя пользователями
  Future<bool> isMatch(String uid1, String uid2) async {
    final sorted = [uid1, uid2]..sort();
    final response = await _supabase
        .from('matches')
        .select('id')
        .eq('user1_id', sorted[0])
        .eq('user2_id', sorted[1])
        .maybeSingle();

    return response != null;
  }

  /// Удалить профиль пользователя
  Future<void> deleteProfile(String uid) async {
    await _supabase.from('profiles').delete().eq('id', uid);
  }
}
