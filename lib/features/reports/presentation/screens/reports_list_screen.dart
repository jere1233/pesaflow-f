// lib/features/reports/presentation/screens/reports_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../../../dashboard/presentation/providers/dashboard_provider.dart';
import '../providers/report_provider.dart';
import '../widgets/report_card.dart';

class ReportsListScreen extends StatefulWidget {
  const ReportsListScreen({super.key});

  @override
  State<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportProvider>().fetchReports();
    });
  }

  Future<void> _onRefresh() async {
    await context.read<ReportProvider>().fetchReports();
  }

  void _showGenerateReportDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Generate Report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the type of report you want to generate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _ReportTypeCard(
              icon: Icons.receipt_long,
              title: 'Transaction Report',
              description: 'Generate a detailed report of your transactions',
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF2563EB)],
              ),
              onTap: () {
                Navigator.pop(context);
                _generateTransactionReport();
              },
            ),
            const SizedBox(height: 12),
            _ReportTypeCard(
              icon: Icons.person,
              title: 'Customer Report',
              description: 'Generate a comprehensive customer profile report',
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
              ),
              onTap: () {
                Navigator.pop(context);
                _generateCustomerReport();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _generateTransactionReport() async {
    final reportProvider = context.read<ReportProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating report...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Fetch transactions if not loaded
    if (dashboardProvider.transactions.isEmpty) {
      await dashboardProvider.fetchTransactions();
    }

    // Convert transactions to map format
    final transactionsData = dashboardProvider.transactions.map((tx) {
      return {
        'id': tx.id,
        'type': tx.type,
        'amount': tx.amount,
        'status': tx.status,
        'createdAt': tx.createdAt.toIso8601String(),
      };
    }).toList();

    // Generate report
    final reportId = await reportProvider.generateTransactionReport(
      title: 'Transaction Report - ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
      transactions: transactionsData,
    );

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (reportId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction report generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh reports list
        await reportProvider.fetchReports();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              reportProvider.errorMessage ?? 'Failed to generate report',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generateCustomerReport() async {
    final reportProvider = context.read<ReportProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generating report...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Fetch user data if not loaded
    if (dashboardProvider.user == null) {
      await dashboardProvider.fetchUserProfile();
    }

    // Fetch transactions if not loaded
    if (dashboardProvider.transactions.isEmpty) {
      await dashboardProvider.fetchTransactions();
    }

    final user = dashboardProvider.user;
    if (user == null) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load user data'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Convert user to map format
    final userData = {
      'id': user.id,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
    };

    // Convert transactions to map format
    final transactionsData = dashboardProvider.transactions.map((tx) {
      return {
        'id': tx.id,
        'type': tx.type,
        'amount': tx.amount,
        'status': tx.status,
        'createdAt': tx.createdAt.toIso8601String(),
      };
    }).toList();

    // Generate report
    final reportId = await reportProvider.generateCustomerReport(
      title: 'Customer Report - ${DateFormat('MMM dd, yyyy').format(DateTime.now())}',
      user: userData,
      transactions: transactionsData,
    );

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (reportId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Customer report generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh reports list
        await reportProvider.fetchReports();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              reportProvider.errorMessage ?? 'Failed to generate report',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.reports.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null && provider.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _onRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No reports yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate your first report to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showGenerateReportDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Generate Report'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.reports.length,
              itemBuilder: (context, index) {
                final report = provider.reports[index];
                return ReportCard(
                  report: report,
                  onTap: () {
                    context.push(
                      '${RouteNames.reportDetail}/${report.id}',
                    );
                  },
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Report'),
                        content: const Text(
                          'Are you sure you want to delete this report? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      final success = await provider.deleteReport(report.id);
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report deleted successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              provider.errorMessage ?? 'Failed to delete report',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGenerateReportDialog,
        icon: const Icon(Icons.add),
        label: const Text('Generate'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _ReportTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ReportTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[200]!,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}