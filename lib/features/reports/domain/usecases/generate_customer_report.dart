// lib/features/reports/domain/usecases/generate_customer_report.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/report_repository.dart';

class GenerateCustomerReport implements UseCase<String, GenerateCustomerReportParams> {
  final ReportRepository repository;

  GenerateCustomerReport(this.repository);

  @override
  Future<Either<Failure, String>> call(GenerateCustomerReportParams params) async {
    return await repository.generateCustomerReport(
      title: params.title,
      user: params.user,
      transactions: params.transactions,
    );
  }
}

class GenerateCustomerReportParams {
  final String title;
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> transactions;

  GenerateCustomerReportParams({
    required this.title,
    required this.user,
    required this.transactions,
  });
}