// lib/features/accounts/presentation/screens/accounts_screen.dart - OPTIONAL NEW SCREEN

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/account_provider.dart';
import '../../domain/entities/account.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Accounts'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AccountProvider>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.accounts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    provider.errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No accounts yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.accounts.length,
              itemBuilder: (context, index) {
                final account = provider.accounts[index];
                return _AccountCard(
                  account: account,
                  onTap: () {
                    provider.selectAccount(account);
                    // Navigate to account details
                    // Navigator.push(context, ...);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;

  const _AccountCard({
    required this.account,
    required this.onTap,
  });

  Color _getTypeColor() {
    switch (account.accountType.toUpperCase()) {
      case 'MANDATORY':
        return AppColors.brandIndigo;
      case 'VOLUNTARY':
        return AppColors.success;
      case 'EMPLOYER':
        return AppColors.brandPurple;
      default:
        return AppColors.secondary;
    }
  }

  Color _getStatusColor() {
    switch (account.accountStatus.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.success;
      case 'SUSPENDED':
        return AppColors.pending;
      case 'CLOSED':
        return AppColors.error;
      case 'FROZEN':
        return AppColors.info;
      default:
        return AppColors.secondary;
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '${account.currency} ',
      decimalDigits: 2,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Account Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getTypeColor().withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      account.accountType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(),
                      ),
                    ),
                  ),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          account.accountStatus,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Account Number
              Text(
                'Account #${account.accountNumber}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Balance
              Text(
                _formatCurrency(account.currentBalance),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                'Available: ${_formatCurrency(account.availableBalance)}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Divider(height: 1),
              
              const SizedBox(height: 16),
              
              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Contributions',
                      value: _formatCurrency(account.totalContributions),
                      icon: Icons.arrow_downward,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Earnings',
                      value: _formatCurrency(account.totalEarnings),
                      icon: Icons.trending_up,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Withdrawn',
                      value: _formatCurrency(account.totalWithdrawn),
                      icon: Icons.arrow_upward,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}