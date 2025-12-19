// lib/features/dashboard/data/models/dashboard_transaction_model.dart

import '../../domain/entities/dashboard_transaction.dart';

class DashboardTransactionModel {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String? description;
  final String? recipientName;
  final String? senderName;
  final DateTime createdAt;

  const DashboardTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    this.description,
    this.recipientName,
    this.senderName,
    required this.createdAt,
  });

  factory DashboardTransactionModel.fromJson(Map<String, dynamic> json) {
    return DashboardTransactionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'unknown',
      amount: _parseDouble(json['amount']),
      status: json['status']?.toString() ?? 'pending',
      description: json['description']?.toString(),
      recipientName: json['recipientName']?.toString() ?? json['recipient_name']?.toString(),
      senderName: json['senderName']?.toString() ?? json['sender_name']?.toString(),
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'status': status,
      'description': description,
      'recipientName': recipientName,
      'senderName': senderName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  DashboardTransaction toEntity() {
    return DashboardTransaction(
      id: id,
      type: type,
      amount: amount,
      status: status,
      description: description,
      recipientName: recipientName,
      senderName: senderName,
      createdAt: createdAt,
    );
  }
}