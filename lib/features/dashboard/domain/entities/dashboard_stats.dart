// lib/features/dashboard/domain/entities/dashboard_stats.dart

import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final double balance;
  final double totalContributions;
  final int completedTransactions;

  const DashboardStats({
    required this.balance,
    required this.totalContributions,
    required this.completedTransactions,
  });

  @override
  List<Object?> get props => [
        balance,
        totalContributions,
        completedTransactions,
      ];

  DashboardStats copyWith({
    double? balance,
    double? totalContributions,
    int? completedTransactions,
  }) {
    return DashboardStats(
      balance: balance ?? this.balance,
      totalContributions: totalContributions ?? this.totalContributions,
      completedTransactions: completedTransactions ?? this.completedTransactions,
    );
  }
}