import 'package:get_it/get_it.dart';

// import '../../features/swipe/data/datasources/mock_swipe_datasource.dart'; // 🎭 ЗАКОММЕНТИРОВАНО
import '../../features/swipe/data/repositories/swipe_repository_impl.dart';
import '../../features/swipe/domain/repositories/swipe_repository.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // ==========================================
  // Features - Swipe
  // ==========================================

  // Data sources
  // 🎭 ЗАКОММЕНТИРОВАНО: используем настоящие сервисы
  // sl.registerLazySingleton<MockSwipeDataSource>(
  //   () => MockSwipeDataSourceImpl(),
  // );

  // Repositories
  sl.registerLazySingleton<SwipeRepository>(
    () => SwipeRepositoryImpl(),
  );

  // ==========================================
  // Core / External (позже добавим Firebase)
  // ==========================================
}
