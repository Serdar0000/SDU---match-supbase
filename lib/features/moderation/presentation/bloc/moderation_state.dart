part of 'moderation_bloc.dart';

@freezed
class ModerationState with _$ModerationState {
  const factory ModerationState.initial() = _Initial;

  const factory ModerationState.loading() = _Loading;

  const factory ModerationState.success({
    required String message,
    required List<String> blockedIds,
  }) = _Success;

  const factory ModerationState.error({
    required String message,
  }) = _Error;

  const factory ModerationState.blockedIdsLoaded(List<String> ids) =
      _BlockedIdsLoaded;
}
