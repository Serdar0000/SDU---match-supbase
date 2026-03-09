import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../services/supabase_service.dart';
import '../services/cloudinary_service.dart';
import '../services/supabase_chat_service.dart';
import '../services/mock_data_service.dart';
import '../../features/moderation/data/datasources/moderation_datasource.dart';
import '../../features/moderation/data/repositories/moderation_repository_impl.dart';
import '../../features/moderation/domain/repositories/moderation_repository.dart';
import '../../features/moderation/presentation/bloc/moderation_bloc.dart';
import '../../features/swipe/presentation/bloc/swipe_bloc.dart';

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

  // 5. Moderation Layer (Reports & Blocks)
  sl.registerLazySingleton<ModerationDataSource>(
    () => ModerationDataSource(supabase: Supabase.instance.client),
  );
  sl.registerLazySingleton<ModerationRepository>(
    () => ModerationRepositoryImpl(dataSource: sl<ModerationDataSource>()),
  );
  sl.registerLazySingleton<ModerationBloc>(
    () => ModerationBloc(repository: sl<ModerationRepository>()),
  );

  // 6. Swipe Bloc
  sl.registerFactory<SwipeBloc>(
    () => SwipeBloc(supabaseService: sl<SupabaseService>()),
  );

  // 7. Mock Data Service — для DEV_MODE
  if (AppConfig.DEV_MODE) {
    sl.registerLazySingleton<MockDataService>(() => MockDataService());
  }
}
