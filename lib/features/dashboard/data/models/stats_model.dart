// lib/features/dashboard/data/models/stats_model.dart

import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel {
  final bool success;
  final double balance;
  final double totalContributions;
  final int completedTransactions;

  const DashboardStatsModel({
    required this.success,
    required this.balance,
    required this.totalContributions,
    required this.completedTransactions,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      success: json['success'] ?? false,
      balance: _parseDouble(json['balance']),
      totalContributions: _parseDouble(json['totalContributions']),
      completedTransactions: _parseInt(json['completedTransactions']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'balance': balance,
      'totalContributions': totalContributions,
      'completedTransactions': completedTransactions,
    };
  }

  DashboardStats toEntity() {
    return DashboardStats(
      balance: balance,
      totalContributions: totalContributions,
      completedTransactions: completedTransactions,
    );
  }
}