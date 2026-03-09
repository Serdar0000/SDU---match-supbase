import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/di/injection.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final SupabaseService _supabaseService;

  SwipeBloc({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? sl<SupabaseService>(),
        super(SwipeInitial()) {
    on<LoadInfos>(_onLoadInfos);
    on<SwipeLeftEvent>(_onSwipeLeft);
    on<SwipeRightEvent>(_onSwipeRight);
    on<CloseMatchEvent>(_onCloseMatch);
  }

  Future<void> _onLoadInfos(LoadInfos event, Emitter<SwipeState> emit) async {
    emit(SwipeLoading());
    try {
      debugPrint('🔄 [SwipeBloc] LoadInfos: Loading profiles for user ${event.currentUserId}');
      
      final swipedIds = await _supabaseService.getSwipedProfileIds(event.currentUserId);
      final blockedIdsList = await _supabaseService.getBlockedUserIds();
      final blockedIds = blockedIdsList.toSet();
      final excludedIds = {...swipedIds, ...blockedIds};

      debugPrint('✅ [SwipeBloc] Excluded IDs: ${excludedIds.length} (swiped: ${swipedIds.length}, blocked: ${blockedIds.length})');

      final currentUser = await _supabaseService.getUserProfile(event.currentUserId);
      
      final profiles = await _supabaseService.getProfilesToSwipe(
        currentUid: event.currentUserId,
        swipedIds: excludedIds.toList(),
        genderFilter: currentUser?.lookingFor,
      );

      debugPrint('✅ [SwipeBloc] Loaded ${profiles.length} profiles');
      emit(SwipeLoaded(profiles: profiles, blockedIds: blockedIds));
    } catch (e) {
      debugPrint('❌ [SwipeBloc] LoadInfos error: $e');
      emit(SwipeError(e.toString()));
    }
  }

  Future<void> _onSwipeLeft(SwipeLeftEvent event, Emitter<SwipeState> emit) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && state is SwipeLoaded) {
      debugPrint('👈 [SwipeBloc] SwipeLeft: Passing ${event.profile.name}');
      try {
        await _supabaseService.saveSwipe(
          fromUid: user.id,
          toUid: event.profile.id,
          action: 'pass',
        );
        debugPrint('✅ [SwipeBloc] Pass saved');
      } catch (e) {
        debugPrint('❌ [SwipeBloc] SwipeLeft error: $e');
      }
    }
  }

  Future<void> _onSwipeRight(SwipeRightEvent event, Emitter<SwipeState> emit) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('❌ [SwipeBloc] SwipeRight: No authenticated user');
      return;
    }
    
    final currentState = state;
    debugPrint('👉 [SwipeBloc] SwipeRight: Liking ${event.profile.name}');

    if (currentState is SwipeLoaded) {
      try {
        debugPrint('⏳ [SwipeBloc] Saving swipe from ${user.id} to ${event.profile.id}');
        
        final matchId = await _supabaseService.saveSwipe(
          fromUid: user.id,
          toUid: event.profile.id,
          action: 'like',
        );

        debugPrint('✅ [SwipeBloc] Swipe saved. matchId: $matchId');

        if (matchId != null) {
          debugPrint('🎉 [SwipeBloc] MATCH FOUND!');
          emit(SwipeMatchState(
            matchedUser: event.profile,
            profiles: currentState.profiles,
            blockedIds: currentState.blockedIds,
            matchId: matchId,
          ));
          // Notify the other user via FCM
          _notifyMatchedUser(
            otherUid: event.profile.id,
            matchId: matchId,
          );
        } else {
          debugPrint('👍 [SwipeBloc] No match yet');
        }
      } catch (e) {
        debugPrint('❌ [SwipeBloc] SwipeRight error: $e');
        emit(SwipeError(e.toString()));
      }
    }
  }

  void _onCloseMatch(CloseMatchEvent event, Emitter<SwipeState> emit) {
    if (state is SwipeMatchState) {
      final currentState = state as SwipeMatchState;
      debugPrint('❌ [SwipeBloc] CloseMatch: Closing overlay, returning to SwipeLoaded');
      emit(SwipeLoaded(
        profiles: currentState.profiles,
        blockedIds: currentState.blockedIds,
      ));
    }
  }

  /// Send push notification to the matched user via Supabase Edge Function.
  Future<void> _notifyMatchedUser({
    required String otherUid,
    required String matchId,
  }) async {
    try {
      // Get current user's name to personalise the notification
      final myProfile = await _supabaseService.getCurrentUserProfile();
      final myName = myProfile?.name ?? 'Someone';

      await Supabase.instance.client.functions.invoke(
        'notify-fcm',
        body: {
          'user_id': otherUid,
          'title': "It's a Match! 🎉",
          'body': '$myName liked you back!',
          'data': {
            'type': 'new_match',
            'matchId': matchId,
            'chat_id': matchId,
          },
        },
      );
      debugPrint('✅ [SwipeBloc] FCM match notification sent to $otherUid');
    } catch (e) {
      debugPrint('❌ [SwipeBloc] Failed to send match notification: $e');
    }
  }
}
