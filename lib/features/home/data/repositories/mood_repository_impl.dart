import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_local_datasource.dart';
import '../datasources/mood_remote_datasource.dart';
import '../models/mood_entry_model.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDatasource _remote;
  final MoodLocalDatasource _local;
  final Logger _logger = Logger();

  MoodRepositoryImpl(this._remote, this._local);

  @override
  Future<Either<Failure, MoodEntryEntity>> generateResponse({
    required String emoji,
    required String thoughts,
  }) async {
    try {
      _logger.i('Generating response for emoji: $emoji');

      final model = await _remote.generateResponse({
        'emoji': emoji,
        'thoughts': thoughts,
      });

      // Persist new entry to cache so history is available offline
      await _local.addEntry(model);

      _logger.i('Response generated and cached: ${model.id}');
      return Right(model.toEntity());
    } on DioException catch (e) {
      _logger.e('DioException: ${e.message}');
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      _logger.e('Unexpected error: $e');
      return Left(NetworkFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MoodEntryEntity>> addLocalEntry({
    required String emoji,
    required String thoughts,
  }) async {
    try {
      final localEntry = MoodEntryModel(
        id: -DateTime.now().millisecondsSinceEpoch,
        emoji: emoji,
        thoughts: thoughts,
        aiResponse: '',
        createdAt: DateTime.now(),
      );

      await _local.addEntry(localEntry);
      _logger.i('Local entry cached: ${localEntry.id}');
      return Right(localEntry.toEntity());
    } catch (e) {
      _logger.e('Failed to cache local entry: $e');
      return Left(NetworkFailure('Failed to save entry locally'));
    }
  }

  @override
  Future<Either<Failure, List<MoodEntryEntity>>> getHistory() async {
    try {
      _logger.i('Fetching mood history from API...');

      final models = await _remote.getHistory();
      final cached = _local.getCachedHistory();
      final localOnly = cached.where((e) => e.id < 0).toList();
      final merged = [...localOnly, ...models];

      // Refresh cache with latest server data and keep local-only entries
      await _local.cacheHistory(merged);

      _logger.i('Fetched ${models.length} entries from API');
      return Right(merged.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      _logger.w('API failed, falling back to cache: ${e.message}');
      return _fallbackToCache(ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      _logger.w('Unexpected error, falling back to cache: $e');
      return _fallbackToCache(NetworkFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(int id) async {
    try {
      await _local.deleteEntry(id);
      _logger.i('Entry $id deleted from cache');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to delete entry $id: $e');
      return Left(NetworkFailure('Failed to delete entry'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllEntries() async {
    try {
      await _local.deleteAllEntries();
      _logger.i('All entries deleted from cache');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to delete all entries: $e');
      return Left(NetworkFailure('Failed to delete all entries'));
    }
  }

  Either<Failure, List<MoodEntryEntity>> _fallbackToCache(Failure failure) {
    final cached = _local.getCachedHistory();
    if (cached.isNotEmpty) {
      _logger.i('Returning ${cached.length} cached entries');
      return Right(cached.map((m) => m.toEntity()).toList());
    }
    return Left(failure);
  }
}
