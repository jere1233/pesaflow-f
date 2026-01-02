// lib/features/reports/data/repositories/report_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;
  final Logger logger;

  ReportRepositoryImpl({
    required this.remoteDataSource,
    required this.logger,
  });

  @override
  Future<Either<Failure, String>> generateTransactionReport({
    required String title,
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      final reportId = await remoteDataSource.generateTransactionReport(
        title: title,
        transactions: transactions,
      );
      return Right(reportId);
    } on ServerException catch (e) {
      logger.error('Repository: ServerException - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: NetworkException - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      logger.error('Repository: UnauthorizedException - ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> generateCustomerReport({
    required String title,
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> transactions,
  }) async {
    try {
      final reportId = await remoteDataSource.generateCustomerReport(
        title: title,
        user: user,
        transactions: transactions,
      );
      return Right(reportId);
    } on ServerException catch (e) {
      logger.error('Repository: ServerException - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: NetworkException - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      logger.error('Repository: UnauthorizedException - ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> getReports() async {
    try {
      final reports = await remoteDataSource.getReports();
      return Right(reports.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      logger.error('Repository: ServerException - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: NetworkException - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      logger.error('Repository: UnauthorizedException - ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Report>> getReportById(String reportId) async {
    try {
      final report = await remoteDataSource.getReportById(reportId);
      return Right(report.toEntity());
    } on ServerException catch (e) {
      logger.error('Repository: ServerException - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: NetworkException - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      logger.error('Repository: UnauthorizedException - ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReport(String reportId) async {
    try {
      await remoteDataSource.deleteReport(reportId);
      return const Right(null);
    } on ServerException catch (e) {
      logger.error('Repository: ServerException - ${e.message}');
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      logger.error('Repository: NetworkException - ${e.message}');
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      logger.error('Repository: UnauthorizedException - ${e.message}');
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      logger.error('Repository: Unexpected error - $e');
      return Left(ServerFailure('An unexpected error occurred'));
    }
  }
}