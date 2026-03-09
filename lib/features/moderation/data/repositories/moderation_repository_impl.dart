import '../datasources/moderation_datasource.dart';
import '../../domain/repositories/moderation_repository.dart';

class ModerationRepositoryImpl implements ModerationRepository {
  final ModerationDataSource _dataSource;

  // Кэш для заблокированных ID (обновляется из стрима)
  List<String> _cachedBlockedIds = [];

  ModerationRepositoryImpl({required ModerationDataSource dataSource})
      : _dataSource = dataSource {
    // Слушаем поток изменений и обновляем кэш
    _dataSource.watchBlockedIds().listen((ids) {
      _cachedBlockedIds = ids;
    });
  }

  @override
  Future<void> reportUser({
    required String reportedId,
    required String reason,
    String? details,
  }) async {
    try {
      // Создаём жалобу
      await _dataSource.createReport(
        reportedId: reportedId,
        reason: reason,
        details: details,
      );

      // Автоматически блокируем
      await blockUser(reportedId);
    } catch (e) {
      throw Exception('Failed to report user: $e');
    }
  }

  @override
  Future<void> blockUser(String blockedId) async {
    try {
      await _dataSource.createBlock(blockedId: blockedId);
      // Кэш обновится автоматически из стрима
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  @override
  Future<void> unblockUser(String blockedId) async {
    try {
      await _dataSource.deleteBlock(blockedId: blockedId);
      // Кэш обновится автоматически из стрима
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  @override
  Stream<List<String>> getBlockedIdsStream() {
    return _dataSource.watchBlockedIds();
  }

  @override
  Future<List<String>> getBlockedIds() async {
    try {
      return await _dataSource.getBlockedIds();
    } catch (e) {
      // В случае ошибки возвращаем кэшированные данные
      return _cachedBlockedIds;
    }
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    try {
      await _dataSource.deleteUserAccount(userId);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
