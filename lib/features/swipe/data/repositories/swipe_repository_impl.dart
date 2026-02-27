import '../../../../core/utils/injection_container.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/swipe_repository.dart';
import '../datasources/mock_swipe_datasource.dart';

class SwipeRepositoryImpl implements SwipeRepository {
  // Как ты и просил: без конструкторов, получаем зависимость напрямую через GetIt
  final mockDataSource = sl<MockSwipeDataSource>();

  @override
  List<UserProfile> getProfiles() {
    // Позже здесь будет логика: если есть интернет -> берем из Firebase,
    // если нет -> берем из кэша. Пока берем мок-данные.
    return mockDataSource.getMockProfiles();
  }
}
