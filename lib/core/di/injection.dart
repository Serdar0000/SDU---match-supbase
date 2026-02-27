import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../services/supabase_service.dart';
import '../services/cloudinary_service.dart';
import '../services/supabase_chat_service.dart';
import '../services/mock_data_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. База данных (Drift) — для локального кэша
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // 2. Supabase Service — для работы с облаком
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // 3. Cloudinary Service — для загрузки фотографий
  sl.registerLazySingleton<CloudinaryService>(() => CloudinaryService());

  // 4. Supabase Chat Service — для реального чата
  sl.registerLazySingleton<SupabaseChatService>(() => SupabaseChatService());

  // 5. Mock Data Service — для DEV_MODE
  if (AppConfig.DEV_MODE) {
    sl.registerLazySingleton<MockDataService>(() => MockDataService());
  }
}
