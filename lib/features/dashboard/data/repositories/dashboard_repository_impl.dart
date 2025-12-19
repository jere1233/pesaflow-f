// lib/features/dashboard/data/repositories/dashboard_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/dashboard_transaction.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Logger logger;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.logger,
  });

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getUserProfile');
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      logger.info('Repository: Fetching user profile');
      final userModel = await remoteDataSource.getUserProfile();
      final user = userModel.toEntity();
      
      logger.info('Repository: Successfully fetched user profile - ${user.email}');
      return Right(user);
    } on UnauthorizedException catch (e) {
      logger.error('Repository: Unauthorized - ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<DashboardTransaction>>> getTransactions() async {
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getTransactions');
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      logger.info('Repository: Fetching transactions');
      final transactionModels = await remoteDataSource.getTransactions();
      final transactions = transactionModels
          .map((model) => model.toEntity())
          .toList();
      
      logger.info('Repository: Successfully fetched ${transactions.length} transactions');
      return Right(transactions);
    } on UnauthorizedException catch (e) {
      logger.error('Repository: Unauthorized - ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, DashboardStats>> getStats() async {
    if (!await networkInfo.isConnected) {
      logger.warning('No internet connection - getStats');
      return Left(NetworkFailure('No internet connection'));
    }

    try {
      logger.info('Repository: Fetching stats');
      final statsModel = await remoteDataSource.getStats();
      final stats = statsModel.toEntity();
      
      logger.info('Repository: Successfully fetched stats');
      return Right(stats);
    } on UnauthorizedException catch (e) {
      logger.error('Repository: Unauthorized - ${e.message}');
      return Left(AuthenticationFailure(e.message));
    } on ServerException catch (e) {
      logger.error('Repository: Server exception - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: Network exception - ${e.message}');
      return Left(NetworkFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(UnexpectedFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}