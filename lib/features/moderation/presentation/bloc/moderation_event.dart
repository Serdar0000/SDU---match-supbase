part of 'moderation_bloc.dart';

@freezed
class ModerationEvent with _$ModerationEvent {
  const factory ModerationEvent.reportUserRequested({
    required String reportedId,
    required String reason,
    String? details,
  }) = _ReportUserRequested;

  const factory ModerationEvent.blockUserRequested({
    required String blockedId,
  }) = _BlockUserRequested;

  const factory ModerationEvent.unblockUserRequested({
    required String blockedId,
  }) = _UnblockUserRequested;

  const factory ModerationEvent.blockedIdsRequested() = _BlockedIdsRequested;

  const factory ModerationEvent.blockedIdsUpdated(List<String> ids) =
      _BlockedIdsUpdated;

  const factory ModerationEvent.deleteAccountRequested() =
      _DeleteAccountRequested;
}
