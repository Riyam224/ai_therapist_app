import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/streak_repository.dart';
import '../../domain/entities/plant_stage.dart';
import 'plant_state.dart';

class PlantCubit extends Cubit<PlantState> {
  final StreakRepository repo;

  PlantCubit(this.repo) : super(PlantInitial());

  Future<void> loadPlant() async {
    emit(PlantLoading());
    try {
      final streak = await repo.calculateStreak();
      emit(PlantLoaded(
        stage: PlantStage.fromStreak(streak),
        streakDays: streak,
      ));
    } catch (_) {
      emit(PlantLoaded(
        stage: PlantStage.seed,
        streakDays: 0,
      ));
    }
  }
}
