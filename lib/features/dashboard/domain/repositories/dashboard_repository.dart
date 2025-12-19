// lib/features/dashboard/domain/repositories/dashboard_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../authentication/domain/entities/user.dart';
import '../entities/dashboard_stats.dart';
import '../entities/dashboard_transaction.dart';

abstract class DashboardRepository {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, List<DashboardTransaction>>> getTransactions();
  Future<Either<Failure, DashboardStats>> getStats();
}
