
///home/hp/JERE/pension/lib/features/authentication/data/models/user_model.dart

import '../../domain/entities/user.dart';

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? json['phoneNumber']?.toString() ?? '',
      profileImage: json['profile_image']?.toString() ?? json['profileImage']?.toString(),
      accountNumber: json['account_number']?.toString() ?? json['accountNumber']?.toString(),
      balance: json['balance'] != null ? double.tryParse(json['balance'].toString()) : null,
      isVerified: json['is_verified'] ?? json['isVerified'],
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
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
      );
}
