part of 'chat_bloc.dart';

@freezed
sealed class ChatState with _$ChatState {
  /// Начальное состояние (ещё не загружено)
  const factory ChatState.initial() = ChatInitial;

  /// Идёт загрузка первых сообщений
  const factory ChatState.loading() = ChatLoading;

  /// Сообщения загружены и обновляются в реальном времени
  const factory ChatState.loaded({
    required String matchId,
    required List<ChatMessage> messages,
    @Default(false) bool isSending,
  }) = ChatLoaded;

  /// Ошибка
  const factory ChatState.error(String message) = ChatError;
}
