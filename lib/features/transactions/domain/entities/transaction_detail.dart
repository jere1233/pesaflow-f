// lib/features/transactions/domain/entities/transaction_detail.dart

class TransactionDetail {
  final String id;
  final String type; // 'credit', 'debit', 'transfer'
  final double amount;
  final String currency;
  final String description;
  final DateTime timestamp;
  final String status; // 'completed', 'pending', 'failed'
  final String category;
  final String? recipientName;
  final String? recipientAccount;
  final String? senderName;
  final String? senderAccount;
  final String? referenceNumber;
  final double? balanceAfter;
  final String? notes;
  final Map<String, dynamic>? metadata;

  TransactionDetail({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.timestamp,
    required this.status,
    required this.category,
    this.recipientName,
    this.recipientAccount,
    this.senderName,
    this.senderAccount,
    this.referenceNumber,
    this.balanceAfter,
    this.notes,
    this.metadata,
  });

  bool get isCredit => type.toLowerCase() == 'credit';
  bool get isDebit => type.toLowerCase() == 'debit';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isFailed => status.toLowerCase() == 'failed';
}