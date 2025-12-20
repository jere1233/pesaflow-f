// lib/features/transactions/data/repositories/transaction_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
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
      final transactions = await remoteDataSource.getAllTransactions(
        page: page,
        limit: limit,
        type: type,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, TransactionDetail>> getTransactionById(
    String id,
  ) async {
    try {
      final transaction = await remoteDataSource.getTransactionById(id);
      return Right(transaction);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionDetail>>> searchTransactions(
    String query,
  ) async {
    try {
      final transactions = await remoteDataSource.searchTransactions(query);
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionDetail>>> getTransactionsByCategory(
    String category,
  ) async {
    try {
      final transactions =
          await remoteDataSource.getTransactionsByCategory(category);
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}