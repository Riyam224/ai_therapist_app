import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_local_datasource.dart';
import '../datasources/mood_remote_datasource.dart';
import '../models/mood_entry_model.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDatasource _remote;
  final MoodLocalDatasource _local;
  final SupabaseClient _supabase;
  final Logger _logger = Logger();

  MoodRepositoryImpl(this._remote, this._local, this._supabase);

  String get _currentUserId =>
      _supabase.auth.currentUser?.id ?? '';

  @override
  Future<Either<Failure, MoodEntryEntity>> generateResponse({
    required String emoji,
    required String thoughts,
  }) async {
    try {
      _logger.i('Generating response for emoji: $emoji');

      final MoodEntryModel model = await _remote.generateResponse({
        'user_id': _currentUserId,
        'emoji': emoji,
        'thoughts': thoughts,
      });

      await _local.addEntry(model);

      _logger.i('Response generated and cached: id=${model.id}');
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
        id: 0,
        userId: _currentUserId,
        emoji: emoji,
        thoughts: thoughts,
        aiResponse: '',
        createdAt: DateTime.now(),
      );

      await _local.addEntry(localEntry);
      _logger.i('Local entry cached');
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

      final List<MoodEntryModel> models =
          await _remote.getHistory(userId: _currentUserId);

      // Guard: only keep entries that belong to the current user
      final userModels = models
          .where((m) => m.userId == _currentUserId)
          .toList();

      await _local.cacheHistory(userModels);

      _logger.i('Fetched ${userModels.length} entries for current user');
      return Right(userModels.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      _logger.w('API failed, falling back to cache: ${e.message}');
      return _fallbackToCache(
          ServerFailure(e.message ?? 'Server error occurred'));
    } catch (e) {
      _logger.w('Unexpected error, falling back to cache: $e');
      return _fallbackToCache(NetworkFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(int id) async {
    try {
      await _local.deleteEntry(id);
      _logger.i('Entry deleted from cache: id=$id');
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to delete entry: $e');
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
    final cached = _local
        .getCachedHistory()
        .where((e) => e.userId == _currentUserId)
        .toList();
    if (cached.isNotEmpty) {
      _logger.i('Returning ${cached.length} cached entries for current user');
      return Right(cached.map((m) => m.toEntity()).toList());
    }
    return Left(failure);
  }
}
