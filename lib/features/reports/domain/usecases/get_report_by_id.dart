// lib/features/reports/domain/usecases/get_report_by_id.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReportById implements UseCase<Report, String> {
  final ReportRepository repository;

  GetReportById(this.repository);

  @override
  Future<Either<Failure, Report>> call(String reportId) async {
    return await repository.getReportById(reportId);
  }
}