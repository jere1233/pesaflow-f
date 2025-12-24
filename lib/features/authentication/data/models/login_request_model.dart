///home/hp/JERE/pension-frontend/lib/features/authentication/data/models/login_request_model.dart
class LoginRequestModel {
  final String identifier; // email or username
  final String password;

  const LoginRequestModel({
    required this.identifier,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      identifier: json['identifier']?.toString() ?? json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}
