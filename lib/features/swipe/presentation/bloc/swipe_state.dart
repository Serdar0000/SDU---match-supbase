part of 'swipe_bloc.dart';

abstract class SwipeState {}

class SwipeInitial extends SwipeState {}

class SwipeLoading extends SwipeState {}

class SwipeLoaded extends SwipeState {
  final List<UserProfile> profiles;
  final Set<String> blockedIds;

  SwipeLoaded({required this.profiles, required this.blockedIds});
}

class SwipeMatchState extends SwipeState {
  final UserProfile matchedUser;
  final List<UserProfile> profiles; // Keep profiles to show behind overlay
  final Set<String> blockedIds;
  final String? matchId;

  SwipeMatchState({
    required this.matchedUser, 
    required this.profiles,
    required this.blockedIds,
    this.matchId,
  });
}

class SwipeError extends SwipeState {
  final String message;
  SwipeError(this.message);
}
