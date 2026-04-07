import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/saved_quotes_repository.dart';

class DeleteQuoteUseCase {
  final SavedQuotesRepository _repository;

  DeleteQuoteUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteQuote(id);
  }
}
