part of 'swipe_bloc.dart';

abstract class SwipeEvent {}

class LoadInfos extends SwipeEvent {
  final String currentUserId;
  LoadInfos(this.currentUserId);
}

class SwipeLeftEvent extends SwipeEvent {
  final UserProfile profile;
  SwipeLeftEvent(this.profile);
}

class SwipeRightEvent extends SwipeEvent {
  final UserProfile profile;
  SwipeRightEvent(this.profile);
}

class CloseMatchEvent extends SwipeEvent {}
