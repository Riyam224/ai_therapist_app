//

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import 'mood_state.dart';

class MoodCubit extends Cubit<MoodState> {
  final MoodRepository _repository;
  final Logger _logger = Logger();

  List<MoodEntryEntity> _cachedEntries = [];

  MoodCubit(this._repository) : super(const MoodInitial());

  // 🔥 ADD THIS METHOD
  Future<void> loadEntries() async {
    await getHistory();
  }

  // Generate AI response and prepend to cached history
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
        _cachedEntries = [entry, ..._cachedEntries];
        emit(MoodHistorySuccess(_cachedEntries, justGenerated: entry));
      },
    );
  }

  // Delete a single entry from cache and update state
  Future<void> deleteEntry(int id) async {
    _cachedEntries = _cachedEntries.where((e) => e.id != id).toList();
    emit(MoodHistorySuccess(_cachedEntries));
    await _repository.deleteEntry(id);
  }

  // Delete all entries from cache and update state
  Future<void> deleteAllEntries() async {
    _cachedEntries = [];
    emit(const MoodHistorySuccess([]));
    await _repository.deleteAllEntries();
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
        _cachedEntries = entries;
        emit(MoodHistorySuccess(entries));
      },
    );
  }
}
