import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_detail.dart';

abstract class TransactionRepository {
  Future<Either<Failure, List<TransactionDetail>>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<Either<Failure, TransactionDetail>> getTransactionById(
    String transactionId,
  );

  Future<Either<Failure, List<TransactionDetail>>> searchTransactions(
    String query,
  );

  Future<Either<Failure, List<TransactionDetail>>> getTransactionsByCategory(
    String category,
  );
}