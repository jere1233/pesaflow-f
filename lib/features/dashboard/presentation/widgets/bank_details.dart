// lib/features/dashboard/presentation/widgets/bank_details.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class BankDetails extends StatelessWidget {
  final String? bankName;
  final String? accountNumber;

  const BankDetails({
    super.key,
    this.bankName,
    this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    final bank = bankName ?? 'Kenya Commercial Bank';
    final account = accountNumber ?? '1234567890';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Bank Account',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Bank', value: bank),
          _DetailRow(label: 'Account Type', value: 'Savings'),
          _DetailRow(
            label: 'Account Number',
            value: '****${account.substring(account.length - 4)}',
          ),
          _DetailRow(
            label: 'Status',
            value: 'Verified',
            valueWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Verified',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
          const Divider(height: 24),
          _DetailRow(label: 'Swift Code', value: 'KCBLKENA'),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          valueWidget ??
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
        ],
      ),
    );
  }
}