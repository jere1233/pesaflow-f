// lib/features/reports/domain/usecases/generate_transaction_report.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/report_repository.dart';

class GenerateTransactionReport implements UseCase<String, GenerateTransactionReportParams> {
  final ReportRepository repository;

  GenerateTransactionReport(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateTransactionReportParams params) async {
    return await repository.generateTransactionReport(
      title: params.title,
      transactions: params.transactions,
    );
  }
}

class GenerateTransactionReportParams {
  final String title;
  final List<Map<String, dynamic>> transactions;

  GenerateTransactionReportParams({
    required this.title,
    required this.transactions,
  });
}