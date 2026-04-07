import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_quote_entity.dart';

abstract class SavedQuotesRepository {
  Future<Either<Failure, List<SavedQuoteEntity>>> getQuotes();
  Future<Either<Failure, SavedQuoteEntity>> saveQuote(String text);
  Future<Either<Failure, void>> deleteQuote(String id);
}
