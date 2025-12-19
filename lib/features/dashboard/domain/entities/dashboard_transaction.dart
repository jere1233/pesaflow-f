// lib/features/dashboard/domain/entities/dashboard_transaction.dart

import 'package:equatable/equatable.dart';

class DashboardTransaction extends Equatable {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String? description;
  final String? recipientName;
  final String? senderName;
  final DateTime createdAt;

  const DashboardTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    this.description,
    this.recipientName,
    this.senderName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        status,
        description,
        recipientName,
        senderName,
        createdAt,
      ];

  bool get isDebit => type.toLowerCase() == 'debit' || type.toLowerCase() == 'send';
  bool get isCredit => type.toLowerCase() == 'credit' || type.toLowerCase() == 'receive';

  String get displayName {
    if (isDebit && recipientName != null) return recipientName!;
    if (isCredit && senderName != null) return senderName!;
    return description ?? 'Transaction';
  }
}