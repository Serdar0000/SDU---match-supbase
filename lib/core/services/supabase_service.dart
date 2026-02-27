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
      'stars_given': profile.starsGiven ?? 0, // Супер-лайки (по умолчанию 0)
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

  /// Получить профили для свайпа (исключая себя и уже просвайпанных)
  Future<List<UserProfile>> getProfilesToSwipe({
    required String currentUid,
    required List<String> swipedIds,
    String? genderFilter,
  }) async {
    // Базовый запрос - исключаем себя
    var query = _supabase.from('profiles').select().neq('id', currentUid);

    // Фильтр по полу, если указан
    if (genderFilter != null && genderFilter != 'all') {
      query = query.eq('gender', genderFilter);
    }

    final response = await query.limit(50);

    // Фильтруем уже свайпнутых на клиенте
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

  /// Сохранить свайп. Возвращает matchId если это взаимный лайк, иначе null
  Future<String?> saveSwipe({
    required String fromUid,
    required String toUid,
    required String action, // 'like' или 'pass'
  }) async {
    await _supabase.from('swipes').insert({
      'from_user_id': fromUid,
      'to_user_id': toUid,
      'action': action,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Если это лайк — проверяем на взаимность
    if (action == 'like') {
      return await _checkForMatch(fromUid, toUid);
    }
    return null;
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

  /// Проверить взаимный лайк и создать матч. Возвращает matchId если матч создан.
  Future<String?> _checkForMatch(String fromUid, String toUid) async {
    // Проверяем: лайкнул ли toUid нас (fromUid)?
    final reverseSwipe = await _supabase
        .from('swipes')
        .select()
        .eq('from_user_id', toUid)
        .eq('to_user_id', fromUid)
        .eq('action', 'like')
        .maybeSingle();

    if (reverseSwipe != null) {
      // Взаимный лайк! Создаём матч
      final sorted = [fromUid, toUid]..sort();
      final matchData = {
        'user1_id': sorted[0],
        'user2_id': sorted[1],
        'last_message': '',
        'last_message_time': DateTime.now().toIso8601String(),
        'unread_count_user1': 0,
        'unread_count_user2': fromUid == sorted[0] ? 1 : 0,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabase
          .from('matches')
          .insert(matchData)
          .select()
          .single();

      return response['id'] as String;
    }
    return null;
  }

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
