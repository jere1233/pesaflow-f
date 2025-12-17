// lib/features/home/data/repositories/home_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// Implementation of HomeRepository
/// Handles data operations and error handling
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Logger logger;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.logger,
  });

  @override
  Future<Either<Failure, Account>> getAccountBalance() async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getAccountBalance');
      return Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      logger.info('Repository: Fetching account balance');
      final accountModel = await remoteDataSource.getAccountBalance();
      final account = accountModel.toEntity();
      
      logger.info('Repository: Successfully fetched account balance - ${account.accountNumber}');
      return Right(account);
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      logger.error('Repository: Format exception - ${e.message}');
      return Left(DataParsingFailure('Failed to parse account data: ${e.message}'));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions({int limit = 10}) async {
    // Validate limit
    if (limit <= 0 || limit > 50) {
      logger.warning('Invalid transaction limit: $limit');
      return Left(ValidationFailure('Transaction limit must be between 1 and 50'));
    }

    // Check network connectivity
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getRecentTransactions');
      return Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      logger.info('Repository: Fetching recent transactions (limit: $limit)');
      final transactionModels = await remoteDataSource.getRecentTransactions(limit: limit);
      final transactions = transactionModels.map((model) => model.toEntity()).toList();
      
      logger.info('Repository: Successfully fetched ${transactions.length} transactions');
      return Right(transactions);
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      logger.error('Repository: Format exception - ${e.message}');
      return Left(DataParsingFailure('Failed to parse transaction data: ${e.message}'));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Account>> refreshAccount() async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - refreshAccount');
      return Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      logger.info('Repository: Refreshing account data');
      final accountModel = await remoteDataSource.refreshAccount();
      final account = accountModel.toEntity();
      
      logger.info('Repository: Successfully refreshed account - ${account.accountNumber}');
      return Right(account);
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      logger.error('Repository: Format exception - ${e.message}');
      return Left(DataParsingFailure('Failed to parse account data: ${e.message}'));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Account>>> getAllAccounts() async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getAllAccounts');
      return Left(NetworkFailure('No internet connection. Please check your network settings.'));
    }

    try {
      logger.info('Repository: Fetching all accounts');
      final accountModels = await remoteDataSource.getAllAccounts();
      final accounts = accountModels.map((model) => model.toEntity()).toList();
      
      logger.info('Repository: Successfully fetched ${accounts.length} accounts');
      return Right(accounts);
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on FormatException catch (e) {
      logger.error('Repository: Format exception - ${e.message}');
      return Left(DataParsingFailure('Failed to parse accounts data: ${e.message}'));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}