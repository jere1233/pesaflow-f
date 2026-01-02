// lib/features/reports/presentation/providers/report_provider.dart

import 'package:flutter/material.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/report.dart';
import '../../domain/usecases/delete_report.dart';
import '../../domain/usecases/generate_customer_report.dart';
import '../../domain/usecases/generate_transaction_report.dart';
import '../../domain/usecases/get_report_by_id.dart';
import '../../domain/usecases/get_reports.dart';

class ReportProvider extends ChangeNotifier {
  final GenerateTransactionReport generateTransactionReportUseCase;
  final GenerateCustomerReport generateCustomerReportUseCase;
  final GetReports getReportsUseCase;
  final GetReportById getReportByIdUseCase;
  final DeleteReport deleteReportUseCase;

  ReportProvider({
    required this.generateTransactionReportUseCase,
    required this.generateCustomerReportUseCase,
    required this.getReportsUseCase,
    required this.getReportByIdUseCase,
    required this.deleteReportUseCase,
  });

  // State
  List<Report> _reports = [];
  Report? _selectedReport;
  bool _isLoading = false;
  bool _isGenerating = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<Report> get reports => _reports;
  Report? get selectedReport => _selectedReport;
  bool get isLoading => _isLoading;
  bool get isGenerating => _isGenerating;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Generate transaction report
  Future<String?> generateTransactionReport({
    required String title,
    required List<Map<String, dynamic>> transactions,
  }) async {
    _isGenerating = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await generateTransactionReportUseCase(
      GenerateTransactionReportParams(
        title: title,
        transactions: transactions,
      ),
    );

    _isGenerating = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return null;
      },
      (reportId) {
        _successMessage = 'Transaction report generated successfully';
        notifyListeners();
        return reportId;
      },
    );
  }

  // Generate customer report
  Future<String?> generateCustomerReport({
    required String title,
    required Map<String, dynamic> user,
    required List<Map<String, dynamic>> transactions,
  }) async {
    _isGenerating = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final result = await generateCustomerReportUseCase(
      GenerateCustomerReportParams(
        title: title,
        user: user,
        transactions: transactions,
      ),
    );

    _isGenerating = false;

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return null;
      },
      (reportId) {
        _successMessage = 'Customer report generated successfully';
        notifyListeners();
        return reportId;
      },
    );
  }

  // Get all reports
  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getReportsUseCase(NoParams());

    _isLoading = false;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (reports) {
        _reports = reports;
        notifyListeners();
      },
    );
  }

  // Get report by ID
  Future<void> fetchReportById(String reportId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getReportByIdUseCase(reportId);

    _isLoading = false;

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (report) {
        _selectedReport = report;
        notifyListeners();
      },
    );
  }

  // Delete report
  Future<bool> deleteReport(String reportId) async {
    _errorMessage = null;
    _successMessage = null;

    final result = await deleteReportUseCase(reportId);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _successMessage = 'Report deleted successfully';
        _reports.removeWhere((report) => report.id == reportId);
        if (_selectedReport?.id == reportId) {
          _selectedReport = null;
        }
        notifyListeners();
        return true;
      },
    );
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Clear selected report
  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }
}