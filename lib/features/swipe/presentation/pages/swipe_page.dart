import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sdu_match/core/config/app_config.dart';
import 'package:sdu_match/core/theme/app_theme.dart';
import 'package:sdu_match/core/services/supabase_service.dart';
import 'package:sdu_match/core/di/injection.dart' as di;
import 'package:sdu_match/core/services/mock_data_service.dart';
import '../../domain/entities/user_profile.dart';
import '../widgets/profile_card.dart';
import '../widgets/swipe_action_buttons.dart';
import '../../../chat/presentation/widgets/match_popup.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final CardSwiperController controller = CardSwiperController();
  final SupabaseService _supabaseService = SupabaseService();
  late final MockDataService? _mockService;
  List<UserProfile> profiles = [];
  bool isLoading = true;
  bool isDone = false; // показали все карточки в этой сессии
  UserProfile? _currentUserProfile;

  // Храним IDs тех, кого свайпнули В ЭТОЙ СЕССИИ — чтобы никогда не перезаписать
  final Set<String> _swipedThisSession = {};

  @override
  void initState() {
    super.initState();
    if (AppConfig.DEV_MODE) {
      _mockService = di.sl<MockDataService>();
    } else {
      _mockService = null;
    }
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    // 🚧 DEV MODE: Используем моковые данные
    if (AppConfig.DEV_MODE && _mockService != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _currentUserProfile = _mockService.currentUserProfile;
        profiles = _mockService.swipeProfiles;
        isLoading = false;
      });
      return;
    }
    
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Загружаем свой профиль (для фильтра lookingFor)
    _currentUserProfile = await _supabaseService.getUserProfile(user.id);

    // Получаем ID уже просвайпанных профилей из Supabase
    final swipedIds = await _supabaseService.getSwipedProfileIds(user.id);

    // Загружаем профили с фильтром по полу
    final loadedProfiles = await _supabaseService.getProfilesToSwipe(
      currentUid: user.id,
      swipedIds: swipedIds,
      genderFilter: _currentUserProfile?.lookingFor,
    );

    setState(() {
      profiles = loadedProfiles;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    final profile = profiles[previousIndex];
    String action;
    
    // Определяем действие по направлению
    if (direction == CardSwiperDirection.right) {
      action = 'like';
    } else if (direction == CardSwiperDirection.top) {
      action = 'superlike'; // Супер-лайк!
      _incrementStarCounter(); // 🌟 Увеличиваем счетчик
    } else {
      action = 'pass';
    }

    debugPrint('Свайп $direction: профиль ${profile.name} ($action)');

    // Защита от повторной записи
    if (_swipedThisSession.contains(profile.id)) {
      if (currentIndex == null) {
        setState(() => isDone = true);
      }
      return true;
    }
    
    _swipedThisSession.add(profile.id);
    
    // 🚧 DEV MODE: Используем моковую логику
    if (AppConfig.DEV_MODE) {
      _handleSwipeAsyncMock(profile: profile, action: action);
    } else {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _handleSwipeAsync(fromUid: user.id, profile: profile, action: action);
      }
    }

    // Если это была последняя карточка — переходим в состояние «всё просмотрено»
    if (currentIndex == null) {
      setState(() => isDone = true);
    }

    return true;
  }

  Future<void> _handleSwipeAsync({
    required String fromUid,
    required UserProfile profile,
    required String action,
  }) async {
    try {
      final matchId = await _supabaseService.saveSwipe(
        fromUid: fromUid,
        toUid: profile.id,
        action: action,
      );

      // Если есть матч — показываем попап
      if (matchId != null && mounted) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          builder: (_) => MatchPopup(
            matchedProfile: profile,
            matchId: matchId,
            myProfile: _currentUserProfile,
          ),
        );
      }
    } catch (e) {
      debugPrint('Ошибка записи свайпа: $e');
    }
  }

  /// 🎭 MOCK VERSION: Симуляция матча для DEV_MODE
  Future<void> _handleSwipeAsyncMock({
    required UserProfile profile,
    required String action,
  }) async {
    // Показываем матч с 50% вероятностью при лайке или суперлайке
    if ((action == 'like' || action == 'superlike') && 
        DateTime.now().millisecond % 2 == 0 && 
        mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (_) => MatchPopup(
          matchedProfile: profile,
          matchId: 'mock-match-${profile.id}',
          myProfile: _currentUserProfile,
        ),
      );
    }
  }

  /// 🌟 Увеличиваем счетчик супер-лайков у текущего пользователя
  Future<void> _incrementStarCounter() async {
    if (_currentUserProfile == null) return;
    
    // 🚧 DEV MODE: Просто обновляем локально
    if (AppConfig.DEV_MODE) {
      setState(() {
        _currentUserProfile = _currentUserProfile!.copyWith(
          starsGiven: _currentUserProfile!.starsGiven + 1,
        );
      });
      debugPrint('🌟 Супер-лайк раздан! Теперь у вас: ${_currentUserProfile!.starsGiven} звездочек');
      return;
    }
    
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    
    final newCount = _currentUserProfile!.starsGiven + 1;
    await _supabaseService.updateUserProfile(user.id, {'stars_given': newCount});
    
    setState(() {
      _currentUserProfile = _currentUserProfile!.copyWith(starsGiven: newCount);
    });
    
    debugPrint('🌟 Супер-лайк раздан! Теперь у вас: $newCount звездочек');
  }

  /// Экран "все карточки просмотрены"
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('😴', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              'Новых анкет пока нет',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Загляни позже — скоро появятся новые люди',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  isDone = false;
                  _swipedThisSession.clear();
                });
                _loadProfiles();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Обновить'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLike() {
    if (profiles.isNotEmpty && !isLoading && !isDone) {
      controller.swipe(CardSwiperDirection.right);
    }
  }

  void _handlePass() {
    if (profiles.isNotEmpty && !isLoading && !isDone) {
      controller.swipe(CardSwiperDirection.left);
    }
  }

  void _handleSuperLike() {
    if (profiles.isNotEmpty && !isLoading && !isDone) {
      controller.swipe(CardSwiperDirection.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canInteract = !isLoading && !isDone && profiles.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SDU Match',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primaryBlue),
            onPressed: () {
              // TODO: Открыть фильтры
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (profiles.isEmpty || isDone)
                      ? _buildEmptyState()
                      : CardSwiper(
                          controller: controller,
                          cardsCount: profiles.length,
                          isLoop: false,
                          numberOfCardsDisplayed: profiles.length.clamp(1, 2),
                          onSwipe: _onSwipe,
                          padding: const EdgeInsets.all(24.0),
                          allowedSwipeDirection: const AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                          ),
                          cardBuilder: (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) {
                            return ProfileCard(
                              profile: profiles[index],
                              swipeProgress: horizontalThresholdPercentage,
                            );
                          },
                        ),
            ),
            // Кнопки действий
            SwipeActionButtons(
              onSuperLike: _handleSuperLike,
              onPass: _handlePass,
              onLike: _handleLike,
              isEnabled: canInteract,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
