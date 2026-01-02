// lib/features/reports/domain/usecases/get_reports.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReports implements UseCase<List<Report>, NoParams> {
  final ReportRepository repository;

  GetReports(this.repository);

  @override
  Future<Either<Failure, List<Report>>> call(NoParams params) async {
    return await repository.getReports();
  }
}