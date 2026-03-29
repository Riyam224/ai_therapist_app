import 'package:ai_therapist_app/core/networking/dio_helper.dart';
import 'package:get_it/get_it.dart';
import '../../features/home/data/datasources/mood_local_datasource.dart';
import '../../features/home/data/datasources/mood_remote_datasource.dart';
import '../../features/home/data/repositories/mood_repository_impl.dart';
import '../../features/home/domain/repositories/mood_repository.dart';
import '../../features/home/presentation/cubit/mood_cubit.dart';

final sl = GetIt.instance;

void setupInjection() {
  // ── Dio ──
  sl.registerLazySingleton(() => DioHelper());

  // ── DataSources ──
  sl.registerLazySingleton<MoodRemoteDatasource>(
    () => MoodRemoteDatasource(sl<DioHelper>().dio!),
  );
  sl.registerLazySingleton<MoodLocalDatasource>(() => MoodLocalDatasource());

  // ── Repository ──
  sl.registerLazySingleton<MoodRepository>(
    () => MoodRepositoryImpl(sl(), sl()),
  );

  // ── Cubit — factory always ──
  sl.registerFactory(() => MoodCubit(sl()));
}
