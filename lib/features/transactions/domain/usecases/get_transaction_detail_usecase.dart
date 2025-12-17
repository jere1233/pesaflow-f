// lib/features/transactions/domain/usecases/get_transaction_detail_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_detail.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionDetailUseCase {
  final TransactionRepository repository;

  GetTransactionDetailUseCase(this.repository);

  Future<Either<Failure, TransactionDetail>> call(String transactionId) async {
    if (transactionId.isEmpty) {
      return Left(ValidationFailure('Transaction ID cannot be empty'));
    }
    
    return await repository.getTransactionById(transactionId);
  }
}