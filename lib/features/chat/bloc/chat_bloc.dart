import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/services/supabase_chat_service.dart';
import '../domain/entities/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';
part 'chat_bloc.freezed.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SupabaseChatService _chatService;

  String? _matchId;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  ChatBloc({required SupabaseChatService chatService})
      : _chatService = chatService,
        super(const ChatState.initial()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatMarkedAsRead>(_onMarkedAsRead);
    on<ChatMessagesReceived>(_onMessagesReceived);
    on<ChatStreamError>(_onStreamError);
  }

  // ──────────────────────────────────────────────
  // Обработчики событий
  // ──────────────────────────────────────────────

  Future<void> _onStarted(
      ChatStarted event, Emitter<ChatState> emit) async {
    _matchId = event.matchId;
    emit(const ChatState.loading());

    // Отмечаем прочитанными при открытии
    await _chatService.markAsRead(event.matchId);

    // Отменяем предыдущую подписку (если было переоткрытие)
    await _messagesSubscription?.cancel();

    // Подписываемся на стрим — при каждом обновлении добавляем внутреннее событие
    _messagesSubscription = _chatService
        .getMessages(event.matchId)
        .listen(
          (messages) {
            add(ChatEvent.messagesReceived(messages));
          },
          onError: (Object e) {
            add(ChatEvent.streamError(e.toString()));
          },
        );
  }

  void _onStreamError(
      ChatStreamError event, Emitter<ChatState> emit) {
    emit(ChatState.error(event.message));
  }

  void _onMessagesReceived(
      ChatMessagesReceived event, Emitter<ChatState> emit) {
    emit(ChatState.loaded(
      matchId: _matchId ?? '',
      messages: event.messages,
    ));
  }

  Future<void> _onMessageSent(
      ChatMessageSent event, Emitter<ChatState> emit) async {
    final current = state;
    if (current is! ChatLoaded) return;
    if (event.text.trim().isEmpty) return;

    // Показываем индикатор отправки
    emit(current.copyWith(isSending: true));

    try {
      await _chatService.sendMessage(
        matchId: current.matchId,
        text: event.text,
      );
      // Используем АКТУАЛЬНЫЙ стейт (стрим мог уже обновить messages)
      final latest = state;
      if (latest is ChatLoaded) {
        emit(latest.copyWith(isSending: false));
      }
    } catch (e) {
      final latest = state;
      if (latest is ChatLoaded) {
        emit(latest.copyWith(isSending: false));
      }
      emit(ChatState.error(e.toString()));
    }
  }

  Future<void> _onMarkedAsRead(
      ChatMarkedAsRead event, Emitter<ChatState> emit) async {
    if (_matchId == null) return;
    await _chatService.markAsRead(_matchId!);
  }

  // ──────────────────────────────────────────────
  // Очистка
  // ──────────────────────────────────────────────

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
