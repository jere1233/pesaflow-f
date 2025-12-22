import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final String tokenType;
  final int expiresIn;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.tokenType = 'Bearer',
    this.expiresIn = 3600,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token']?.toString() ?? json['accessToken']?.toString() ?? json['token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString() ?? json['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
      tokenType: json['token_type']?.toString() ?? json['tokenType']?.toString() ?? 'Bearer',
      expiresIn: json['expires_in'] ?? json['expiresIn'] ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}
