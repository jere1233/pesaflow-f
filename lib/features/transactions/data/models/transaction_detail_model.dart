// lib/features/transactions/data/models/transaction_detail_model.dart

import '../../domain/entities/transaction_detail.dart';

class TransactionDetailModel extends TransactionDetail {
  TransactionDetailModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.currency,
    required super.description,
    required super.timestamp,
    required super.status,
    required super.category,
    super.recipientName,
    super.recipientAccount,
    super.senderName,
    super.senderAccount,
    super.referenceNumber,
    super.balanceAfter,
    super.notes,
    super.metadata,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency']?.toString() ?? 'KES',
      description: json['description']?.toString() ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: json['status']?.toString() ?? 'completed',
      category: json['category']?.toString() ?? 'other',
      recipientName: json['recipient_name']?.toString(),
      recipientAccount: json['recipient_account']?.toString(),
      senderName: json['sender_name']?.toString(),
      senderAccount: json['sender_account']?.toString(),
      referenceNumber: json['reference_number']?.toString(),
      balanceAfter: json['balance_after'] != null
          ? (json['balance_after']).toDouble()
          : null,
      notes: json['notes']?.toString(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'currency': currency,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'category': category,
      'recipient_name': recipientName,
      'recipient_account': recipientAccount,
      'sender_name': senderName,
      'sender_account': senderAccount,
      'reference_number': referenceNumber,
      'balance_after': balanceAfter,
      'notes': notes,
      'metadata': metadata,
    };
  }

  TransactionDetailModel copyWith({
    String? id,
    String? type,
    double? amount,
    String? currency,
    String? description,
    DateTime? timestamp,
    String? status,
    String? category,
    String? recipientName,
    String? recipientAccount,
    String? senderName,
    String? senderAccount,
    String? referenceNumber,
    double? balanceAfter,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return TransactionDetailModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      category: category ?? this.category,
      recipientName: recipientName ?? this.recipientName,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      senderName: senderName ?? this.senderName,
      senderAccount: senderAccount ?? this.senderAccount,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}