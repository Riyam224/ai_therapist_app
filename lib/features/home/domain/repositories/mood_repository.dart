import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/mood_entry_entity.dart';

abstract class MoodRepository {
  Future<Either<Failure, MoodEntryEntity>> generateResponse({
    required String emoji,
    required String thoughts,
  });

  Future<Either<Failure, List<MoodEntryEntity>>> getHistory();

  Future<Either<Failure, void>> deleteEntry(int id);
}
