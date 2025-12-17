// lib/features/home/domain/entities/account.dart

import 'package:equatable/equatable.dart';

/// Account entity representing user's bank account
/// This is a pure domain entity with no external dependencies
class Account extends Equatable {
  final String id;
  final String accountNumber;
  final String accountName;
  final String accountType; // e.g., 'savings', 'current', 'fixed'
  final double balance;
  final double availableBalance;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastTransactionDate;

  const Account({
    required this.id,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.balance,
    required this.availableBalance,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    this.lastTransactionDate,
  });

  /// Check if account has sufficient balance for a transaction
  bool hasSufficientBalance(double amount) {
    return availableBalance >= amount;
  }

  /// Check if account can perform transactions
  bool canTransact() {
    return isActive && availableBalance > 0;
  }

  /// Get formatted account number (e.g., **** **** 1234)
  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    final lastFour = accountNumber.substring(accountNumber.length - 4);
    return '**** **** $lastFour';
  }

  @override
  List<Object?> get props => [
        id,
        accountNumber,
        accountName,
        accountType,
        balance,
        availableBalance,
        currency,
        isActive,
        createdAt,
        lastTransactionDate,
      ];

  @override
  bool get stringify => true;
}