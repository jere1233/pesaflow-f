// lib/features/dashboard/presentation/providers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/dashboard_transaction.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository repository;

  DashboardProvider({required this.repository});

  // State
  User? _user;
  List<DashboardTransaction> _transactions = [];
  DashboardStats? _stats;
  
  bool _isLoadingProfile = false;
  bool _isLoadingTransactions = false;
  bool _isLoadingStats = false;
  
  String? _errorMessage;

  // Getters
  User? get user => _user;
  List<DashboardTransaction> get transactions => _transactions;
  DashboardStats? get stats => _stats;
  
  bool get isLoadingProfile => _isLoadingProfile;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingStats => _isLoadingStats;
  bool get isLoading => _isLoadingProfile || _isLoadingTransactions || _isLoadingStats;
  
  String? get errorMessage => _errorMessage;

  // Recent transactions (limit to 3)
  List<DashboardTransaction> get recentTransactions {
    return _transactions.take(3).toList();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    await Future.wait([
      fetchUserProfile(),
      fetchTransactions(),
      fetchStats(),
    ]);
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getUserProfile();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoadingProfile = false;
        notifyListeners();
      },
      (user) {
        _user = user;
        _isLoadingProfile = false;
        notifyListeners();
      },
    );
  }

  // Fetch transactions
  Future<void> fetchTransactions() async {
    _isLoadingTransactions = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getTransactions();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoadingTransactions = false;
        notifyListeners();
      },
      (transactions) {
        _transactions = transactions;
        _isLoadingTransactions = false;
        notifyListeners();
      },
    );
  }

  // Fetch stats
  Future<void> fetchStats() async {
    _isLoadingStats = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getStats();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoadingStats = false;
        notifyListeners();
      },
      (stats) {
        _stats = stats;
        _isLoadingStats = false;
        notifyListeners();
      },
    );
  }

  // Refresh all data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clearData() {
    _user = null;
    _transactions = [];
    _stats = null;
    _errorMessage = null;
    notifyListeners();
  }
}