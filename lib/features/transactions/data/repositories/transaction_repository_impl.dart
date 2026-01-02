import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_detail.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TransactionDetail>>> getAllTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final transactionModels = await remoteDataSource.getAllTransactions(
        page: page,
        limit: limit,
        type: type,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );

      final transactions = transactionModels
          .map((model) => model.toEntity())
          .toList();

      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionDetail>> getTransactionById(
    String transactionId,
  ) async {
    try {
      final transactionModel = await remoteDataSource.getTransactionById(
        transactionId,
      );

      return Right(transactionModel.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionDetail>>> searchTransactions(
    String query,
  ) async {
    try {
      final transactionModels = await remoteDataSource.searchTransactions(query);

      final transactions = transactionModels
          .map((model) => model.toEntity())
          .toList();

      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TransactionDetail>>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final transactionModels = await remoteDataSource.getTransactionsByCategory(
        category,
      );

      final transactions = transactionModels
          .map((model) => model.toEntity())
          .toList();

      return Right(transactions);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}