// lib/features/transactions/domain/usecases/get_all_transactions_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_detail.dart';
import '../repositories/transaction_repository.dart';

class GetAllTransactionsUseCase {
  final TransactionRepository repository;

  GetAllTransactionsUseCase(this.repository);

  Future<Either<Failure, List<TransactionDetail>>> call({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getAllTransactions(
      page: page,
      limit: limit,
      type: type,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}