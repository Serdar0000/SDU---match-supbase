part of 'chat_bloc.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  /// Открыть чат — подписаться на поток сообщений
  const factory ChatEvent.started(String matchId) = ChatStarted;

  /// Отправить сообщение
  const factory ChatEvent.messageSent(String text) = ChatMessageSent;

  /// Отметить сообщения как прочитанные
  const factory ChatEvent.markedAsRead() = ChatMarkedAsRead;

  /// Внутреннее событие: новые данные из stream
  /// (не используйте вне ChatBloc)
  const factory ChatEvent.messagesReceived(
    List<ChatMessage> messages,
  ) = ChatMessagesReceived;

  /// Внутреннее событие: ошибка stream
  /// (не используйте вне ChatBloc)
  const factory ChatEvent.streamError(String message) = ChatStreamError;
}
