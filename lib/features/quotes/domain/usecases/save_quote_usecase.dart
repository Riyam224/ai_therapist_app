import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/saved_quote_entity.dart';
import '../repositories/saved_quotes_repository.dart';

class SaveQuoteUseCase {
  final SavedQuotesRepository _repository;

  SaveQuoteUseCase(this._repository);

  Future<Either<Failure, SavedQuoteEntity>> call(String text) {
    return _repository.saveQuote(text);
  }
}
