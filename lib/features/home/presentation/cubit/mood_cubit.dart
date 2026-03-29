import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/repositories/mood_repository.dart';
import 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepository _repository;
  final Logger _logger = Logger();

  MoodCubit(this._repository) : super(const MoodInitial());

  // Generate AI response
  Future<void> generateResponse({
    required String emoji,
    required String thoughts,
  }) async {
    emit(const MoodLoading());
    _logger.i('MoodCubit: generating response...');

    final result = await _repository.generateResponse(
      emoji: emoji,
      thoughts: thoughts,
    );

    result.fold(
      (failure) {
        _logger.e('MoodCubit error: ${failure.message}');
        emit(MoodError(failure.message));
      },
      (entry) {
        _logger.i('MoodCubit: success — entry id: ${entry.id}');
        emit(MoodGenerateSuccess(entry));
      },
    );
  }

  // Get history
  Future<void> getHistory() async {
    emit(const MoodLoading());
    _logger.i('MoodCubit: fetching history...');

    final result = await _repository.getHistory();

    result.fold(
      (failure) {
        _logger.e('MoodCubit history error: ${failure.message}');
        emit(MoodError(failure.message));
      },
      (entries) {
        _logger.i('MoodCubit: ${entries.length} entries loaded');
        emit(MoodHistorySuccess(entries));
      },
    );
  }
}
