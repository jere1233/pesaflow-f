import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';

class TransactionDetailScreen extends StatefulWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<TransactionProvider>()
          .loadTransactionDetail(widget.transactionId);
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.category;
    
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'utilities':
        return Icons.lightbulb;
      case 'entertainment':
        return Icons.movie;
      case 'salary':
        return Icons.attach_money;
      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Transaction Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Implement download receipt
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download receipt')),
              );
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.status == TransactionStatus.loading) {
            return const Center(child: CustomLoadingIndicator());
          }

          if (provider.status == TransactionStatus.error) {
            return CustomErrorWidget(
              message: provider.errorMessage ?? 'Failed to load details',
              onRetry: () => provider.loadTransactionDetail(widget.transactionId),
            );
          }

          final transaction = provider.selectedTransaction;
          if (transaction == null) {
            return const Center(child: Text('Transaction not found'));
          }

          final isCredit = transaction.isCredit;
          final amountColor = isCredit ? Colors.green : Colors.red;
          final amountPrefix = isCredit ? '+' : '-';

          return SingleChildScrollView(
            child: Column(
              children: [
                // Status Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          transaction.status.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount
                      Text(
                        '$amountPrefix${transaction.currency} ${transaction.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Description
                      Text(
                        transaction.description ?? 'No description',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Transaction Info Cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Basic Info Card
                      _InfoCard(
                        title: 'Transaction Information',
                        children: [
                          _InfoRow(
                            icon: Icons.fingerprint,
                            label: 'Transaction ID',
                            value: transaction.id,
                            onTap: () => _copyToClipboard(
                              transaction.id,
                              'Transaction ID',
                            ),
                          ),
                          if (transaction.category != null)
                            _InfoRow(
                              icon: _getCategoryIcon(transaction.category),
                              label: 'Category',
                              value: transaction.category ?? 'N/A',
                            ),
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: 'Date & Time',
                            value: DateFormat('MMM dd, yyyy • hh:mm a')
                                .format(transaction.timestamp ?? transaction.createdAt),
                          ),
                          if (transaction.referenceNumber != null)
                            _InfoRow(
                              icon: Icons.numbers,
                              label: 'Reference Number',
                              value: transaction.referenceNumber!,
                              onTap: () => _copyToClipboard(
                                transaction.referenceNumber!,
                                'Reference Number',
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Party Info Card
                      if (transaction.recipientName != null ||
                          transaction.senderName != null)
                        _InfoCard(
                          title: isCredit ? 'From' : 'To',
                          children: [
                            if (transaction.recipientName != null) ...[
                              _InfoRow(
                                icon: Icons.person,
                                label: 'Name',
                                value: transaction.recipientName!,
                              ),
                              if (transaction.recipientAccount != null)
                                _InfoRow(
                                  icon: Icons.account_balance,
                                  label: 'Account',
                                  value: transaction.recipientAccount!,
                                  onTap: () => _copyToClipboard(
                                    transaction.recipientAccount!,
                                    'Account Number',
                                  ),
                                ),
                            ],
                            if (transaction.senderName != null) ...[
                              _InfoRow(
                                icon: Icons.person,
                                label: 'Name',
                                value: transaction.senderName!,
                              ),
                              if (transaction.senderAccount != null)
                                _InfoRow(
                                  icon: Icons.account_balance,
                                  label: 'Account',
                                  value: transaction.senderAccount!,
                                ),
                            ],
                          ],
                        ),

                      if (transaction.recipientName != null ||
                          transaction.senderName != null)
                        const SizedBox(height: 16),

                      // Additional Info Card
                      _InfoCard(
                        title: 'Additional Details',
                        children: [
                          if (transaction.balanceAfter != null)
                            _InfoRow(
                              icon: Icons.account_balance_wallet,
                              label: 'Balance After',
                              value:
                                  '${transaction.currency} ${transaction.balanceAfter!.toStringAsFixed(2)}',
                            ),
                          if (transaction.notes != null)
                            _InfoRow(
                              icon: Icons.note,
                              label: 'Notes',
                              value: transaction.notes!,
                            ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.support_agent),
                              label: const Text('Get Help'),
                              onPressed: () {
                                // Navigate to support
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.receipt),
                              label: const Text('Receipt'),
                              onPressed: () {
                                // Show receipt
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.copy, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}