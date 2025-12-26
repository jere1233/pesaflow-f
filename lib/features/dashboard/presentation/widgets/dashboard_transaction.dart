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

  // Helper getters
  bool get isDebit => type.toLowerCase() == 'debit' || type.toLowerCase() == 'contribution';
  bool get isCredit => type.toLowerCase() == 'credit' || type.toLowerCase() == 'incoming';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isPending => status.toLowerCase() == 'pending';
  
  String get displayName {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    if (isDebit) {
      return recipientName ?? 'Contribution';
    }
    return senderName ?? 'Incoming';
  }

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

  DashboardTransaction copyWith({
    String? id,
    String? type,
    double? amount,
    String? status,
    String? description,
    String? recipientName,
    String? senderName,
    DateTime? createdAt,
  }) {
    return DashboardTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      description: description ?? this.description,
      recipientName: recipientName ?? this.recipientName,
      senderName: senderName ?? this.senderName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}