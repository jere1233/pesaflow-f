// lib/features/reports/domain/repositories/report_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/report.dart';

abstract class ReportRepository {
  Future<Either<Failure, String>> generateTransactionReport({
    required String title,
    required List<Map<String, dynamic>> transactions,
  });

  Future<Either<Failure, String>> generateCustomerReport({
    required String title,
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> transactions,
  });

  Future<Either<Failure, List<Report>>> getReports();

  Future<Either<Failure, Report>> getReportById(String reportId);

  Future<Either<Failure, void>> deleteReport(String reportId);
}