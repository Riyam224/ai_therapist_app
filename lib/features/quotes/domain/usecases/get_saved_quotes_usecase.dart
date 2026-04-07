import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_quote_entity.dart';
import '../repositories/saved_quotes_repository.dart';

class GetSavedQuotesUseCase {
  final SavedQuotesRepository _repository;

  GetSavedQuotesUseCase(this._repository);

  Future<Either<Failure, List<SavedQuoteEntity>>> call() {
    return _repository.getQuotes();
  }
}
