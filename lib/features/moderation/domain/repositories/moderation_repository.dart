abstract class ModerationRepository {
  /// Пожаловаться на пользователя + автоматически заблокировать
  Future<void> reportUser({
    required String reportedId,
    required String reason,
    String? details,
  });

  /// Заблокировать пользователя (с удалением матча и сообщений)
  Future<void> blockUser(String blockedId);

  /// Разблокировать пользователя
  Future<void> unblockUser(String blockedId);

  /// Получить поток заблокированных ID
  Stream<List<String>> getBlockedIdsStream();

  /// Получить список заблокированных ID (однократно)
  Future<List<String>> getBlockedIds();

  /// Удалить аккаунт пользователя (GDPR)
  Future<void> deleteUserAccount(String userId);
}
