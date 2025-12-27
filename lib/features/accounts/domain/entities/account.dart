// lib/features/accounts/domain/entities/account.dart

import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final int id;
  final String accountNumber;
  final String accountType;
  final String accountStatus;
  final String riskProfile;
  final String currency;
  final double currentBalance;
  final double availableBalance;
  final double lockedBalance;
  final double employeeContributions;
  final double employerContributions;
  final double voluntaryContributions;
  final double interestEarned;
  final double investmentReturns;
  final double dividendsEarned;
  final double totalWithdrawn;
  final double taxWithheld;
  final bool kycVerified;
  final String complianceStatus;
  final DateTime openedAt;
  final DateTime? lastContributionAt;
  final DateTime? lastWithdrawalAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.accountNumber,
    required this.accountType,
    required this.accountStatus,
    required this.riskProfile,
    required this.currency,
    required this.currentBalance,
    required this.availableBalance,
    required this.lockedBalance,
    required this.employeeContributions,
    required this.employerContributions,
    required this.voluntaryContributions,
    required this.interestEarned,
    required this.investmentReturns,
    required this.dividendsEarned,
    required this.totalWithdrawn,
    required this.taxWithheld,
    required this.kycVerified,
    required this.complianceStatus,
    required this.openedAt,
    this.lastContributionAt,
    this.lastWithdrawalAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper getters
  double get totalContributions =>
      employeeContributions + employerContributions + voluntaryContributions;

  double get totalEarnings =>
      interestEarned + investmentReturns + dividendsEarned;

  bool get isActive => accountStatus.toUpperCase() == 'ACTIVE';
  bool get isSuspended => accountStatus.toUpperCase() == 'SUSPENDED';
  bool get isClosed => accountStatus.toUpperCase() == 'CLOSED';
  bool get isFrozen => accountStatus.toUpperCase() == 'FROZEN';

  bool get isMandatory => accountType.toUpperCase() == 'MANDATORY';
  bool get isVoluntary => accountType.toUpperCase() == 'VOLUNTARY';
  bool get isEmployer => accountType.toUpperCase() == 'EMPLOYER';

  @override
  List<Object?> get props => [
        id,
        accountNumber,
        accountType,
        accountStatus,
        riskProfile,
        currency,
        currentBalance,
        availableBalance,
        lockedBalance,
        employeeContributions,
        employerContributions,
        voluntaryContributions,
        interestEarned,
        investmentReturns,
        dividendsEarned,
        totalWithdrawn,
        taxWithheld,
        kycVerified,
        complianceStatus,
        openedAt,
        lastContributionAt,
        lastWithdrawalAt,
        createdAt,
        updatedAt,
      ];

  Account copyWith({
    int? id,
    String? accountNumber,
    String? accountType,
    String? accountStatus,
    String? riskProfile,
    String? currency,
    double? currentBalance,
    double? availableBalance,
    double? lockedBalance,
    double? employeeContributions,
    double? employerContributions,
    double? voluntaryContributions,
    double? interestEarned,
    double? investmentReturns,
    double? dividendsEarned,
    double? totalWithdrawn,
    double? taxWithheld,
    bool? kycVerified,
    String? complianceStatus,
    DateTime? openedAt,
    DateTime? lastContributionAt,
    DateTime? lastWithdrawalAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      accountStatus: accountStatus ?? this.accountStatus,
      riskProfile: riskProfile ?? this.riskProfile,
      currency: currency ?? this.currency,
      currentBalance: currentBalance ?? this.currentBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      lockedBalance: lockedBalance ?? this.lockedBalance,
      employeeContributions: employeeContributions ?? this.employeeContributions,
      employerContributions: employerContributions ?? this.employerContributions,
      voluntaryContributions: voluntaryContributions ?? this.voluntaryContributions,
      interestEarned: interestEarned ?? this.interestEarned,
      investmentReturns: investmentReturns ?? this.investmentReturns,
      dividendsEarned: dividendsEarned ?? this.dividendsEarned,
      totalWithdrawn: totalWithdrawn ?? this.totalWithdrawn,
      taxWithheld: taxWithheld ?? this.taxWithheld,
      kycVerified: kycVerified ?? this.kycVerified,
      complianceStatus: complianceStatus ?? this.complianceStatus,
      openedAt: openedAt ?? this.openedAt,
      lastContributionAt: lastContributionAt ?? this.lastContributionAt,
      lastWithdrawalAt: lastWithdrawalAt ?? this.lastWithdrawalAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}