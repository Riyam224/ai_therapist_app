import 'package:ai_therapist_app/core/networking/dio_helper.dart';
import 'package:ai_therapist_app/features/plant/data/repositories/streak_repository.dart';
import 'package:ai_therapist_app/features/plant/presentation/cubit/plant_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/supabase_auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/data/datasources/mood_local_datasource.dart';
import '../../features/home/data/datasources/mood_remote_datasource.dart';
import '../../features/home/data/repositories/mood_repository_impl.dart';
import '../../features/home/domain/repositories/mood_repository.dart';
import '../../features/home/presentation/cubit/mood_cubit.dart';

final sl = GetIt.instance;

void setupInjection() {
  // ── Dio ──
  sl.registerLazySingleton(() => DioHelper());

  // ── Supabase ──
  sl.registerLazySingleton(() => Supabase.instance.client);

  // ── Auth DataSource ──
  sl.registerLazySingleton(() => SupabaseAuthDatasource(sl()));

  // ── Auth Repository ──
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // ── Auth UseCases ──
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // ── Auth Cubit — factory always ──
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        logoutUseCase: sl(),
        authRepository: sl(),
      ));

  // ── Mood DataSources ──
  sl.registerLazySingleton<MoodRemoteDatasource>(
    () => MoodRemoteDatasource(sl<DioHelper>().dio!),
  );
  sl.registerLazySingleton<MoodLocalDatasource>(() => MoodLocalDatasource());

  // ── Mood Repository ──
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(sl(), sl()),
  );

  // ── Mood Cubit — singleton so all screens share state ──
  sl.registerLazySingleton(() => MoodCubit(sl()));

  sl.registerLazySingleton<StreakRepository>(
    () => StreakRepository(sl<DioHelper>().dio!),
  );

  sl.registerFactory<PlantCubit>(
    () => PlantCubit(sl<StreakRepository>()), // no SupabaseClient
  );
}
