// lib/features/reports/domain/usecases/delete_report.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/report_repository.dart';

class DeleteReport implements UseCase<void, String> {
  final ReportRepository repository;

  DeleteReport(this.repository);

  @override
  Future<Either<Failure, void>> call(String reportId) async {
    return await repository.deleteReport(reportId);
  }
}