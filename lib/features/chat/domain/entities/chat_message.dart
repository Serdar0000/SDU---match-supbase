import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const ChatMessage._(); // Нужен для кастомных методов

  const factory ChatMessage({
    required String id,
    required String senderId,
    required String text,
    required DateTime timestamp,
    @Default(false) bool isRead,
  }) = _ChatMessage;

  bool get isEmpty => text.trim().isEmpty;
}
