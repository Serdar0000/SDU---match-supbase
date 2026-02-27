import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sdu_match/core/config/app_config.dart';
import 'package:sdu_match/core/di/injection.dart' as di;
import 'package:sdu_match/core/services/mock_data_service.dart';
import '../../../../core/services/supabase_chat_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../swipe/domain/entities/user_profile.dart';
import '../../../chat/presentation/widgets/match_list_tile.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  late final MockDataService? _mockService;
  final SupabaseChatService _chatService = SupabaseChatService();
  final SupabaseService _supabaseService = SupabaseService();
  late final String _currentUid;

  @override
  void initState() {
    super.initState();
    if (AppConfig.DEV_MODE) {
      _mockService = di.sl<MockDataService>();
      _currentUid = MockDataService.currentUserId;
    } else {
      _mockService = null;
      _currentUid = Supabase.instance.client.auth.currentUser?.id ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Чаты',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // 🚧 DEV MODE: используем FutureBuilder с моковыми данными
      body: AppConfig.DEV_MODE
          ? FutureBuilder<List<_MatchWithProfile>>(
              future: _loadMockMatches(),
              builder: (context, snapshot) {
                return _buildContent(context, snapshot, isDark);
              },
            )
          : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatService.getMatchesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                final matches = snapshot.data ?? [];
                return FutureBuilder<List<_MatchWithProfile>>(
                  future: _loadMatchProfiles(matches),
                  builder: (context, profileSnapshot) {
                    return _buildContent(context, profileSnapshot, isDark);
                  },
                );
              },
            ),
    );
  }

  Widget _buildContent(
      BuildContext context, AsyncSnapshot<List<_MatchWithProfile>> snapshot, bool isDark) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Ошибка: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final matchProfiles = snapshot.data ?? [];

    if (matchProfiles.isEmpty) {
      return _buildEmptyState();
    }

    final newMatches = matchProfiles
        .where((m) => (m.data['last_message'] as String? ?? '').isEmpty)
        .toList();
    final activeChats = matchProfiles
        .where((m) => (m.data['last_message'] as String? ?? '').isNotEmpty)
        .toList();

    return CustomScrollView(
      slivers: [
        if (newMatches.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Новые совпадения',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 105,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: newMatches.length,
                itemBuilder: (context, i) {
                  final m = newMatches[i];
                  return NewMatchChip(
                    profile: m.profile,
                    onTap: () => _openChat(m),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Divider(
              height: 1,
              color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
            ),
          ),
        ],
        if (activeChats.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Сообщения',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final m = activeChats[index];
              final lastMsg = AppConfig.DEV_MODE
                  ? _mockService?.getLastMessage(m.profile.id)
                  : null;
              final unreadCount = AppConfig.DEV_MODE
                  ? (_mockService?.getUnreadCount(m.profile.id) ?? 0)
                  : (m.data['user1_id'] == _currentUid
                      ? (m.data['unread_count_user1'] as int? ?? 0)
                      : (m.data['unread_count_user2'] as int? ?? 0));

              return Column(
                children: [
                  MatchListTile(
                    profile: m.profile,
                    lastMessage: AppConfig.DEV_MODE
                        ? (lastMsg?.text ?? '')
                        : (m.data['last_message'] as String? ?? ''),
                    lastMessageTime: AppConfig.DEV_MODE
                        ? lastMsg?.timestamp
                        : (m.data['last_message_time'] != null
                            ? DateTime.parse(m.data['last_message_time'] as String)
                            : null),
                    unreadCount: unreadCount,
                    onTap: () => _openChat(m),
                  ),
                  Divider(
                    height: 1,
                    indent: 72,
                    color: isDark ? AppColors.darkDivider : Colors.grey.shade200,
                  ),
                ],
              );
            },
            childCount: activeChats.length,
          ),
        ),
        if (activeChats.isEmpty && newMatches.isNotEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Напишите первыми! 💬',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 🎭 MOCK VERSION - загружаем моковые данные
  Future<List<_MatchWithProfile>> _loadMockMatches() async {
    await Future.delayed(const Duration(milliseconds: 300)); // имитация загрузки

    final mockService = _mockService!;
    final matchedProfiles = mockService.matchedProfiles;
    final result = <_MatchWithProfile>[];

    for (final profile in matchedProfiles) {
      final lastMsg = mockService.getLastMessage(profile.id);
      result.add(_MatchWithProfile(
        matchId: 'mock-match-${profile.id}',
        profile: profile,
        data: {
          'id': 'mock-match-${profile.id}',
          'users': [MockDataService.currentUserId, profile.id],
          'user1_id': MockDataService.currentUserId,
          'last_message': lastMsg?.text ?? '',
          'last_message_time': lastMsg?.timestamp.toIso8601String(),
          'unread_count_user1': 0,
          'unread_count_user2': mockService.getUnreadCount(profile.id),
        },
      ));
    }

    return result;
  }

  // 📡 SUPABASE VERSION - загружаем профили из реальных матчей
  Future<List<_MatchWithProfile>> _loadMatchProfiles(
      List<Map<String, dynamic>> matches) async {
    final result = <_MatchWithProfile>[];
    for (final match in matches) {
      final users = List<String>.from(match['users'] ?? []);
      final otherUid =
          users.firstWhere((id) => id != _currentUid, orElse: () => '');
      if (otherUid.isEmpty) continue;
      final profile = await _supabaseService.getUserProfile(otherUid);
      if (profile != null) {
        result.add(_MatchWithProfile(
          matchId: match['id'] as String,
          profile: profile,
          data: match,
        ));
      }
    }
    return result;
  }

  void _openChat(_MatchWithProfile m) {
    context.push('/chat/${m.matchId}', extra: m.profile);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: AppColors.primaryBlue.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ещё нет совпадений',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Свайпайте профили,\nчтобы найти своих!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _MatchWithProfile {
  final String matchId;
  final UserProfile profile;
  final Map<String, dynamic> data;

  _MatchWithProfile({
    required this.matchId,
    required this.profile,
    required this.data,
  });
}

// 🎭 Виджет для отображения новых матчей в горизонтальном списке
class NewMatchChip extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onTap;

  const NewMatchChip({
    super.key,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(profile.imageUrl),
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 4),
            Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
