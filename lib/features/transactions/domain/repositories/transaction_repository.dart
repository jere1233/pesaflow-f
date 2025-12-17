// lib/features/transactions/domain/repositories/transaction_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_detail.dart';

abstract class TransactionRepository {
  /// Get all transactions with optional filters
  Future<Either<Failure, List<TransactionDetail>>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get a single transaction by ID
  Future<Either<Failure, TransactionDetail>> getTransactionById(String id);

  /// Search transactions
  Future<Either<Failure, List<TransactionDetail>>> searchTransactions(
    String query,
  );

  /// Get transactions by category
  Future<Either<Failure, List<TransactionDetail>>> getTransactionsByCategory(
    String category,
  );
}