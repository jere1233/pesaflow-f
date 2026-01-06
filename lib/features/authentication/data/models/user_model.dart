import '../../domain/entities/user.dart';

class BankAccount {
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final String? branchCode;
  final String? branchName;

  const BankAccount({
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.branchCode,
    this.branchName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      bankName: json['bankName']?.toString(),
      accountNumber: json['accountNumber']?.toString(),
      accountName: json['accountName']?.toString(),
      branchCode: json['branchCode']?.toString(),
      branchName: json['branchName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bankName != null) 'bankName': bankName,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (accountName != null) 'accountName': accountName,
      if (branchCode != null) 'branchCode': branchCode,
      if (branchName != null) 'branchName': branchName,
    };
  }
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    super.profileImage,
    super.accountNumber,
    super.balance,
    super.isVerified,
    super.createdAt,
    super.bankAccount, // 🆕 NEW FIELD
    super.occupation,
    super.employer,
    super.salary,
    super.contributionRate,
    super.retirementAge,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    BankAccount? bankAccount;
    if (json['bankAccount'] != null) {
      bankAccount = BankAccount.fromJson(json['bankAccount'] as Map<String, dynamic>);
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? json['phoneNumber']?.toString() ?? json['phone']?.toString() ?? '',
      profileImage: json['profile_image']?.toString() ?? json['profileImage']?.toString(),
      accountNumber: json['account_number']?.toString() ?? json['accountNumber']?.toString(),
      balance: json['balance'] != null ? double.tryParse(json['balance'].toString()) : null,
      isVerified: json['is_verified'] ?? json['isVerified'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
      bankAccount: bankAccount, // 🆕 NEW FIELD
      occupation: json['occupation']?.toString(),
      employer: json['employer']?.toString(),
      salary: json['salary'] != null ? double.tryParse(json['salary'].toString()) : null,
      contributionRate: json['contributionRate'] != null ? double.tryParse(json['contributionRate'].toString()) : null,
      retirementAge: json['retirementAge'] != null ? int.tryParse(json['retirementAge'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'account_number': accountNumber,
      'balance': balance,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
      if (bankAccount != null) 'bankAccount': (bankAccount as BankAccount).toJson(),
      if (occupation != null) 'occupation': occupation,
      if (employer != null) 'employer': employer,
      if (salary != null) 'salary': salary,
      if (contributionRate != null) 'contributionRate': contributionRate,
      if (retirementAge != null) 'retirementAge': retirementAge,
    };
  }

  User toEntity() => User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
        accountNumber: accountNumber,
        balance: balance,
        isVerified: isVerified,
        createdAt: createdAt,
        bankAccount: bankAccount,
        occupation: occupation,
        employer: employer,
        salary: salary,
        contributionRate: contributionRate,
        retirementAge: retirementAge,
      );

  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phoneNumber: user.phoneNumber,
        profileImage: user.profileImage,
        accountNumber: user.accountNumber,
        balance: user.balance,
        isVerified: user.isVerified,
        createdAt: user.createdAt,
        bankAccount: user.bankAccount,
        occupation: user.occupation,
        employer: user.employer,
        salary: user.salary,
        contributionRate: user.contributionRate,
        retirementAge: user.retirementAge,
      );
}