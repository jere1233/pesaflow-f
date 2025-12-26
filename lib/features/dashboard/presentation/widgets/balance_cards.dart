// lib/features/dashboard/presentation/widgets/balance_cards.dart

import 'package:flutter/material.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/dashboard_stats.dart';

class BalanceCards extends StatelessWidget {
  final DashboardStats? stats;
  final User? user;

  const BalanceCards({
    super.key,
    this.stats,
    this.user,
  });

  int _calculateMonthlyContribution() {
    // You'll need to add these fields to your User entity
    // For now, using stats data
    return (stats?.totalContributions ?? 0).toInt();
  }

  int _calculateYearsToRetirement() {
    // Calculate based on user's date of birth and retirement age
    // This would need dateOfBirth and retirementAge in User entity
    return 35; // Placeholder
  }

  int _calculateProjectedRetirement() {
    final balance = stats?.balance ?? 0;
    final years = _calculateYearsToRetirement();
    // Simple 8% annual growth calculation
    return (balance * (1 + 0.08 * years)).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final balance = stats?.balance ?? 0;
    final monthlyContrib = _calculateMonthlyContribution();
    final yearsToRetirement = _calculateYearsToRetirement();
    final projectedAt65 = _calculateProjectedRetirement();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: [
        _BalanceCard(
          title: 'Total Balance',
          amount: 'KES ${_formatAmount(balance)}',
          subtitle: 'Across all plans',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
          ),
          icon: Icons.account_balance_wallet,
        ),
        _BalanceCard(
          title: 'Monthly Contribution',
          amount: 'KES ${_formatAmount(monthlyContrib.toDouble())}',
          subtitle: 'Total allocated',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF10B981)],
          ),
          icon: Icons.arrow_downward,
        ),
        _BalanceCard(
          title: 'Projected @ 65',
          amount: 'KES ${_formatAmount(projectedAt65.toDouble())}',
          subtitle: '8% annual growth',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
          ),
          icon: Icons.trending_up,
        ),
        _BalanceCard(
          title: 'Years to Retirement',
          amount: yearsToRetirement.toString(),
          subtitle: 'Target age: 65',
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEA580C), Color(0xFFDC2626)],
          ),
          icon: Icons.access_time,
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;

  const _BalanceCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                icon,
                size: 18,
                color: Colors.white60,
              ),
            ],
          ),
          const Spacer(),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}