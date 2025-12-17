// lib/features/home/presentation/widgets/recent_transactions_list.dart

import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/empty_state_widget.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isLoading;

  const RecentTransactionsList({
    Key? key,
    required this.transactions,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading && transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (transactions.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.receipt_long,
        message: 'No recent transactions',
        description: 'Your transaction history will appear here',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _TransactionListItem(
          transaction: transaction,
          onTap: () {
            // Navigate to transaction details
            Navigator.pushNamed(
              context,
              '/transaction-detail',
              arguments: transaction.id,
            );
          },
        );
      },
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const _TransactionListItem({
    Key? key,
    required this.transaction,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildTransactionIcon(),
      title: Text(
        transaction.description,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          if (transaction.recipientName != null) ...[
            Text(
              transaction.recipientName!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
          ],
          Row(
            children: [
              Text(
                transaction.getFormattedDate(),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusChip(),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.amountSign}${transaction.currency} ${CurrencyFormatter.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: transaction.isCredit ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 2),
          if (transaction.reference != null)
            Text(
              transaction.reference!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionIcon() {
    IconData iconData;
    Color iconColor;

    switch (transaction.type) {
      case TransactionType.credit:
      case TransactionType.deposit:
        iconData = Icons.arrow_downward;
        iconColor = Colors.green;
        break;
      case TransactionType.debit:
      case TransactionType.withdrawal:
        iconData = Icons.arrow_upward;
        iconColor = Colors.red;
        break;
      case TransactionType.transfer:
        iconData = Icons.swap_horiz;
        iconColor = Colors.blue;
        break;
      case TransactionType.payment:
        iconData = Icons.payment;
        iconColor = Colors.purple;
        break;
      case TransactionType.refund:
        iconData = Icons.refresh;
        iconColor = Colors.orange;
        break;
      case TransactionType.fee:
        iconData = Icons.receipt;
        iconColor = Colors.grey;
        break;
      case TransactionType.reversal:
        iconData = Icons.undo;
        iconColor = Colors.amber;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildStatusChip() {
    if (transaction.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Completed',
          style: TextStyle(
            fontSize: 9,
            color: Colors.green[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (transaction.isPending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Pending',
          style: TextStyle(
            fontSize: 9,
            color: Colors.orange[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (transaction.isFailed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Failed',
          style: TextStyle(
            fontSize: 9,
            color: Colors.red[700],
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}