import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sdu_match/core/theme/app_theme.dart';
import '../../domain/entities/user_profile.dart';
import '../../presentation/bloc/swipe_bloc.dart';
import '../widgets/profile_card.dart';
import '../widgets/swipe_action_buttons.dart';
import '../widgets/match_overlay.dart';
import '../../../moderation/presentation/bloc/moderation_bloc.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    // Инициализируем SwipeBloc после первого фрейма
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSwipeBloc();
    });
  }

  void _initializeSwipeBloc() {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null && mounted) {
        debugPrint('🚀 [SwipePage] Initializing SwipeBloc for user: ${user.id}');
        context.read<SwipeBloc>().add(LoadInfos(user.id));
      } else {
        debugPrint('❌ [SwipePage] No user found or widget not mounted');
      }
    } catch (e) {
      debugPrint('❌ [SwipePage] Error initializing SwipeBloc: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SwipeBloc, SwipeState>(
      listener: (context, state) {
        // Слушаем ModerationBloc для обновления блокировок
        if (state is SwipeLoaded) {
          context.read<ModerationBloc>().stream.listen((modState) {
            modState.maybeWhen(
              blockedIdsLoaded: (ids) {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null && mounted) {
                  context.read<SwipeBloc>().add(LoadInfos(user.id));
                }
              },
              orElse: () {},
            );
          });
        }
      },
      child: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
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
            body: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildMainContent(state, context),
                      ),
                      if (state is! SwipeMatchState)
                        SwipeActionButtons(
                          onSuperLike: () => _handleSuperLike(state, context),
                          onPass: () => _handlePass(state, context),
                          onLike: () => _handleLike(state, context),
                          isEnabled: state is SwipeLoaded,
                        ),
                      if (state is! SwipeMatchState) const SizedBox(height: 8),
                    ],
                  ),
                ),
                // MatchOverlay поверх всего
                if (state is SwipeMatchState)
                  MatchOverlay(
                    matchedUser: state.matchedUser,
                    currentUser: _getCurrentUserProfile(state),
                    onKeepSwiping: () {
                      context.read<SwipeBloc>().add(CloseMatchEvent());
                    },
                    onSendMessage: () {
                      final matchId = state.matchId;
                      final matchedUser = state.matchedUser;
                      context.read<SwipeBloc>().add(CloseMatchEvent());
                      if (matchId != null) {
                        context.push('/chat/$matchId', extra: matchedUser);
                      } else {
                        debugPrint('⚠️ matchId is null, cannot open chat');
                      }
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(SwipeState state, BuildContext context) {
    if (state is SwipeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is SwipeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Ошибка: ${state.message}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  context.read<SwipeBloc>().add(LoadInfos(user.id));
                }
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state is SwipeLoaded) {
      if (state.profiles.isEmpty) {
        return _buildEmptyState(context);
      }

      return CardSwiper(
        controller: controller,
        cardsCount: state.profiles.length,
        isLoop: false,
        numberOfCardsDisplayed: state.profiles.length.clamp(1, 2),
        onSwipe: (previousIndex, currentIndex, direction) =>
            _onSwipe(previousIndex, currentIndex, direction, state, context),
        padding: const EdgeInsets.all(24.0),
        allowedSwipeDirection: const AllowedSwipeDirection.only(
          left: true,
          right: true,
          up: true,
        ),
        cardBuilder: (
          context,
          index,
          horizontalThresholdPercentage,
          verticalThresholdPercentage,
        ) {
          return ProfileCard(
            profile: state.profiles[index],
            swipeProgress: horizontalThresholdPercentage,
          );
        },
      );
    }

    if (state is SwipeMatchState) {
      if (state.profiles.isEmpty) {
        return _buildEmptyState(context);
      }

      return CardSwiper(
        controller: controller,
        cardsCount: state.profiles.length,
        isLoop: false,
        numberOfCardsDisplayed: state.profiles.length.clamp(1, 2),
        onSwipe: (previousIndex, currentIndex, direction) =>
            _onSwipe(previousIndex, currentIndex, direction, state, context),
        padding: const EdgeInsets.all(24.0),
        allowedSwipeDirection: const AllowedSwipeDirection.only(
          left: true,
          right: true,
          up: true,
        ),
        cardBuilder: (
          context,
          index,
          horizontalThresholdPercentage,
          verticalThresholdPercentage,
        ) {
          return ProfileCard(
            profile: state.profiles[index],
            swipeProgress: horizontalThresholdPercentage,
          );
        },
      );
    }

    return const Center(child: Text('Unknown state'));
  }

  Widget _buildEmptyState(BuildContext context) {
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
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  context.read<SwipeBloc>().add(LoadInfos(user.id));
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Обновить'),
            ),
          ],
        ),
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
    SwipeState state,
    BuildContext context,
  ) {
    if (state is! SwipeLoaded && state is! SwipeMatchState) {
      return false;
    }

    final profiles = state is SwipeLoaded ? state.profiles : (state as SwipeMatchState).profiles;
    
    if (previousIndex < 0 || previousIndex >= profiles.length) {
      return false;
    }

    final profile = profiles[previousIndex];

    if (direction == CardSwiperDirection.right) {
      context.read<SwipeBloc>().add(SwipeRightEvent(profile));
    } else if (direction == CardSwiperDirection.top) {
      context.read<SwipeBloc>().add(SwipeRightEvent(profile)); // Superlike also counts as like
    } else {
      context.read<SwipeBloc>().add(SwipeLeftEvent(profile));
    }

    return true;
  }

  void _handleLike(SwipeState state, BuildContext context) {
    if (state is SwipeLoaded && state.profiles.isNotEmpty) {
      controller.swipe(CardSwiperDirection.right);
    }
  }

  void _handlePass(SwipeState state, BuildContext context) {
    if (state is SwipeLoaded && state.profiles.isNotEmpty) {
      controller.swipe(CardSwiperDirection.left);
    }
  }

  void _handleSuperLike(SwipeState state, BuildContext context) {
    if (state is SwipeLoaded && state.profiles.isNotEmpty) {
      controller.swipe(CardSwiperDirection.top);
    }
  }

  UserProfile? _getCurrentUserProfile(SwipeState state) {
    // TODO: Get current user profile from your state or context
    return null; // Будет использоваться для показа фото пользователя в оверлее
  }
}
