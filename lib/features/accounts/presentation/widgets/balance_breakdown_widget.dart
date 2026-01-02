// lib/features/accounts/presentation/widgets/balance_breakdown_widget.dart

import 'package:flutter/material.dart';
import '../../domain/entities/account.dart';

class BalanceBreakdownWidget extends StatelessWidget {
  final Account account;

  const BalanceBreakdownWidget({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final total = account.currentBalance;
    final employeePercent = total > 0 ? (account.employeeContributions / total * 100) : 0.0;
    final employerPercent = total > 0 ? (account.employerContributions / total * 100) : 0.0;
    final earningsPercent = total > 0 ? (account.totalEarnings / total * 100) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Employee Contributions
          _buildBreakdownRow(
            icon: Icons.person,
            title: 'Employee Contributions',
            amount: account.employeeContributions,
            percentage: employeePercent,
            color: Colors.green,
          ),
          const SizedBox(height: 20),

          // Employer Contributions
          _buildBreakdownRow(
            icon: Icons.business,
            title: 'Employer Contributions',
            amount: account.employerContributions,
            percentage: employerPercent,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          // Investment Earnings
          _buildBreakdownRow(
            icon: Icons.trending_up,
            title: 'Investment Earnings',
            amount: account.totalEarnings,
            percentage: earningsPercent,
            color: Colors.purple,
          ),

          const Divider(height: 32),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.black87,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'KES ${account.currentBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow({
    required IconData icon,
    required String title,
    required double amount,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'KES ${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}