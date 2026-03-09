import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/moderation_repository.dart';

part 'moderation_event.dart';
part 'moderation_state.dart';
part 'moderation_bloc.freezed.dart';

class ModerationBloc extends Bloc<ModerationEvent, ModerationState> {
  final ModerationRepository _repository;
  StreamSubscription<List<String>>? _blockedIdsSubscription;

  ModerationBloc({required ModerationRepository repository})
      : _repository = repository,
        super(const ModerationState.initial()) {
    on<_ReportUserRequested>(_onReportUserRequested);
    on<_BlockUserRequested>(_onBlockUserRequested);
    on<_UnblockUserRequested>(_onUnblockUserRequested);
    on<_BlockedIdsRequested>(_onBlockedIdsRequested);
    on<_BlockedIdsUpdated>(_onBlockedIdsUpdated);
    on<_DeleteAccountRequested>(_onDeleteAccountRequested);
  }

  Future<void> _onReportUserRequested(
    _ReportUserRequested event,
    Emitter<ModerationState> emit,
  ) async {
    emit(const ModerationState.loading());
    try {
      await _repository.reportUser(
        reportedId: event.reportedId,
        reason: event.reason,
        details: event.details,
      );

      final blockedIds = await _repository.getBlockedIds();
      emit(ModerationState.success(
        message: 'Report sent and user blocked',
        blockedIds: blockedIds,
      ));
    } catch (e) {
      emit(ModerationState.error(message: e.toString()));
    }
  }

  Future<void> _onBlockUserRequested(
    _BlockUserRequested event,
    Emitter<ModerationState> emit,
  ) async {
    emit(const ModerationState.loading());
    try {
      await _repository.blockUser(event.blockedId);

      final blockedIds = await _repository.getBlockedIds();
      emit(ModerationState.success(
        message: 'User blocked',
        blockedIds: blockedIds,
      ));
    } catch (e) {
      emit(ModerationState.error(message: e.toString()));
    }
  }

  Future<void> _onUnblockUserRequested(
    _UnblockUserRequested event,
    Emitter<ModerationState> emit,
  ) async {
    emit(const ModerationState.loading());
    try {
      await _repository.unblockUser(event.blockedId);

      final blockedIds = await _repository.getBlockedIds();
      emit(ModerationState.success(
        message: 'User unblocked',
        blockedIds: blockedIds,
      ));
    } catch (e) {
      emit(ModerationState.error(message: e.toString()));
    }
  }

  Future<void> _onBlockedIdsRequested(
    _BlockedIdsRequested event,
    Emitter<ModerationState> emit,
  ) async {
    try {
      // Отменяем старую подписку
      await _blockedIdsSubscription?.cancel();

      // Слушаем стрим заблокированных ID
      _blockedIdsSubscription = _repository.getBlockedIdsStream().listen(
        (ids) {
          add(ModerationEvent.blockedIdsUpdated(ids));
        },
        onError: (e) {
          emit(ModerationState.error(message: e.toString()));
        },
      );

      // Загружаем начальные данные
      final blockedIds = await _repository.getBlockedIds();
      emit(ModerationState.blockedIdsLoaded(blockedIds));
    } catch (e) {
      emit(ModerationState.error(message: e.toString()));
    }
  }

  void _onBlockedIdsUpdated(
    _BlockedIdsUpdated event,
    Emitter<ModerationState> emit,
  ) {
    emit(ModerationState.blockedIdsLoaded(event.ids));
  }

  Future<void> _onDeleteAccountRequested(
    _DeleteAccountRequested event,
    Emitter<ModerationState> emit,
  ) async {
    emit(const ModerationState.loading());
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _repository.deleteUserAccount(userId);
      
      // Очищаем сессию Supabase после успешного удаления профиля
      // Email будет оставаться в auth.users, но профиль удален
      // поэтому пользователь не сможет логиниться
      await Supabase.instance.client.auth.signOut();
      
      emit(const ModerationState.success(
        message: 'Account deleted',
        blockedIds: [],
      ));
    } catch (e) {
      emit(ModerationState.error(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _blockedIdsSubscription?.cancel();
    return super.close();
  }
}
